#include "GraphicObject.mqh";



class TrendLine : public GraphicObject {
private:
   datetime m_time1;
   double m_price1;
   datetime m_time2;
   double m_price2;
   bool m_ray_left;
   bool m_ray_right;
   
public:
   TrendLine(long curr_chart_id, string name) : GraphicObject(curr_chart_id, name) {
      m_chart_object.NumPoints(2);
      
      m_time1 = m_chart_object.Time(0);
      m_price1 = m_chart_object.Price(0);
      m_time2 = m_chart_object.Time(1);
      m_price2 = m_chart_object.Price(1);
      m_ray_left  = m_chart_object.RayLeft();
      m_ray_right = m_chart_object.RayRight();
   }

   virtual bool CopyToChart(long target_chart_id) override {
      if (ObjectCreate(target_chart_id, m_name, OBJ_TREND, 0, m_time1, m_price1, m_time2, m_price2)) {
         m_chart_object.ChartId(target_chart_id);
         
         m_chart_object.RayLeft(m_ray_left);
         m_chart_object.RayRight(m_ray_right);
         
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
      
      ApplyCommonProperties();
   }
};
