#include "GraphicObject.mqh";


struct FiboLevelProps {
   double value;
   string text;
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
      m_time1 = (datetime)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_TIME, 0);
      m_price1 = ObjectGetDouble(m_curr_chart_id, m_name, OBJPROP_PRICE, 0);
      m_time2 = (datetime)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_TIME, 1);
      m_price2 = ObjectGetDouble(m_curr_chart_id, m_name, OBJPROP_PRICE, 1);
      m_ray_left = (bool)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_RAY_LEFT);
      m_ray_right = (bool)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_RAY_RIGHT);
      m_levels_count = (int)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_LEVELS);
      
      ArrayResize(m_levels, m_levels_count);
      
      for (int i = 0; i < m_levels_count; i++) {
         FiboLevelProps level;
      
         level.value = ObjectGetDouble(m_curr_chart_id, m_name, OBJPROP_LEVELVALUE, i);
         level.text = ObjectGetString(m_curr_chart_id, m_name, OBJPROP_LEVELTEXT, i);
         level.width = (int)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_LEVELWIDTH, i);
         level.clr = (color)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_LEVELCOLOR, i);
         level.style = (ENUM_LINE_STYLE)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_LEVELSTYLE, i);
         
         m_levels[i] = level;
      }
   }

   virtual bool CopyToChart(long target_chart_id) override {
      if (ObjectCreate(target_chart_id, m_name, OBJ_FIBO, 0, m_time1, m_price1, m_time2, m_price2)) {
         ObjectSetInteger(target_chart_id, m_name, OBJPROP_RAY_LEFT, m_ray_left);
         ObjectSetInteger(target_chart_id, m_name, OBJPROP_RAY_RIGHT, m_ray_right);
         ObjectSetInteger(target_chart_id, m_name, OBJPROP_LEVELS, m_levels_count);
         
         for (int i = 0; i < m_levels_count; i++) {
            ObjectSetDouble(target_chart_id, m_name, OBJPROP_LEVELVALUE, i, m_levels[i].value);
            ObjectSetString(target_chart_id, m_name, OBJPROP_LEVELTEXT, i, m_levels[i].text);
            ObjectSetInteger(target_chart_id, m_name, OBJPROP_LEVELWIDTH, i, m_levels[i].width);
            ObjectSetInteger(target_chart_id, m_name, OBJPROP_LEVELCOLOR, i, m_levels[i].clr);
            ObjectSetInteger(target_chart_id, m_name, OBJPROP_LEVELSTYLE, i, m_levels[i].style);
         }
         
         ApplyCommonProperties(target_chart_id);
         
         return true;
      }
      
      return false;
   }
   
   virtual void Drag(long target_chart_id) override {
      ObjectSetInteger(target_chart_id, m_name, OBJPROP_TIME, 0, m_time1);
      ObjectSetDouble(target_chart_id, m_name, OBJPROP_PRICE, 0, m_price1);
      ObjectSetInteger(target_chart_id, m_name, OBJPROP_TIME, 1, m_time2);
      ObjectSetDouble(target_chart_id, m_name, OBJPROP_PRICE, 1, m_price2);
   }
};
