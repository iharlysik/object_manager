#include "GraphicObject.mqh";


struct FiboLevelProps {
   double value;
   string desc;
   int width;
   color clr;
   ENUM_LINE_STYLE style;
};


class Fibo : public GraphicObject {
private:
   datetime m_time1;
   double m_price1;
   datetime m_time2;
   double m_price2;
   bool m_ray_left;
   bool m_ray_right;
   int m_levels_count;
   FiboLevelProps m_levels[];
   
public:
   Fibo(long curr_chart_id, string name) : GraphicObject(curr_chart_id, name) {
      m_chart_object.NumPoints(2);
      
      m_time1 = m_chart_object.Time(0);
      m_price1 = m_chart_object.Price(0);
      m_time2 = m_chart_object.Time(1);
      m_price2 = m_chart_object.Price(1);
      m_ray_left  = m_chart_object.RayLeft();
      m_ray_right = m_chart_object.RayRight();
      
      m_levels_count = m_chart_object.LevelsCount();
      
      ArrayResize(m_levels, m_levels_count);
      
      for (int i = 0; i < m_levels_count; i++) {
         FiboLevelProps level;
      
         level.value = m_chart_object.LevelValue(i);
         level.desc = m_chart_object.LevelDescription(i);
         level.width = m_chart_object.LevelWidth(i);
         level.clr = m_chart_object.LevelColor(i);
         level.style = m_chart_object.LevelStyle(i);
         
         m_levels[i] = level;
      }
   }

   virtual bool CopyToChart(long target_chart_id) override {
      if (ObjectCreate(target_chart_id, m_name, OBJ_FIBO, 0, m_time1, m_price1, m_time2, m_price2)) {
         m_chart_object.ChartId(target_chart_id);
         
         m_chart_object.RayLeft(m_ray_left);
         m_chart_object.RayRight(m_ray_right);
         m_chart_object.LevelsCount(m_levels_count);
         
         for (int i = 0; i < m_levels_count; i++) {
            m_chart_object.LevelValue(i, m_levels[i].value);
            m_chart_object.LevelDescription(i, m_levels[i].desc);
            m_chart_object.LevelWidth(i, m_levels[i].width);
            m_chart_object.LevelColor(i, m_levels[i].clr);
            m_chart_object.LevelStyle(i, m_levels[i].style);
         }
         
         ApplyCommonProperties();
         
         return true;
      }
      
      return false;
   }
   
   virtual void Drag(long target_chart_id) override {
      m_chart_object.ChartId(target_chart_id);
      m_chart_object.SetPoint(0, m_time1, m_price1);
      m_chart_object.SetPoint(1, m_time2, m_price2);
   }
   
   virtual void Change(long target_chart_id) override {
      m_chart_object.ChartId(target_chart_id);
      
      m_chart_object.RayLeft(m_ray_left);
      m_chart_object.RayRight(m_ray_right);
      m_chart_object.SetPoint(0, m_time1, m_price1);
      m_chart_object.SetPoint(1, m_time2, m_price2);
      
      m_chart_object.LevelsCount(m_levels_count);
      
      for (int i = 0; i < m_levels_count; i++) {
         m_chart_object.LevelValue(i, m_levels[i].value);
         m_chart_object.LevelDescription(i, m_levels[i].desc);
         m_chart_object.LevelWidth(i, m_levels[i].width);
         m_chart_object.LevelColor(i, m_levels[i].clr);
         m_chart_object.LevelStyle(i, m_levels[i].style);
      }
      
      ApplyCommonProperties();
   }
};
