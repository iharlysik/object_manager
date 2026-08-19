#include "GraphicObject.mqh";



class Fibo : public GraphicObject {
public:
   Fibo(long chart_id, string name) : GraphicObject(chart_id, name) {}

   virtual bool CopyToChart(long target_chart_id) override {
      datetime time1  = (datetime)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_TIME, 0);
      double   price1 = ObjectGetDouble(m_curr_chart_id, m_name, OBJPROP_PRICE, 0);
      datetime time2  = (datetime)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_TIME, 1);
      double   price2 = ObjectGetDouble(m_curr_chart_id, m_name, OBJPROP_PRICE, 1);
      bool     ray_left  = (bool)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_RAY_LEFT);
      bool     ray_right = (bool)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_RAY_RIGHT);

      if (ObjectCreate(target_chart_id, m_name, OBJ_FIBO, 0, time1, price1, time2, price2)) {
         ObjectSetInteger(target_chart_id, m_name, OBJPROP_TIME, 0, time1);
         ObjectSetDouble(target_chart_id, m_name, OBJPROP_PRICE, 0, price1);
         ObjectSetInteger(target_chart_id, m_name, OBJPROP_TIME, 1, time2);
         ObjectSetDouble(target_chart_id, m_name, OBJPROP_PRICE, 1, price2);
         ObjectSetInteger(target_chart_id, m_name, OBJPROP_RAY_LEFT, ray_left);
         ObjectSetInteger(target_chart_id, m_name, OBJPROP_RAY_RIGHT, ray_right);
         
         // Копируем уровни Фибоначчи и их описания
         int levels = (int)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_LEVELS);
         ObjectSetInteger(target_chart_id, m_name, OBJPROP_LEVELS, levels);
         
         for (int i = 0; i < levels; i++) {
            double value = ObjectGetDouble(m_curr_chart_id, m_name, OBJPROP_LEVELVALUE, i);
            string desc  = ObjectGetString(m_curr_chart_id, m_name, OBJPROP_LEVELTEXT, i);
            int width = (int)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_LEVELWIDTH, i);
            color clrlevel = (color)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_LEVELCOLOR, i);
            ENUM_LINE_STYLE style = (ENUM_LINE_STYLE)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_LEVELSTYLE, i);
            
            ObjectSetDouble(target_chart_id, m_name, OBJPROP_LEVELVALUE, i, value);
            ObjectSetString(target_chart_id, m_name, OBJPROP_LEVELTEXT, i, desc);
            ObjectSetInteger(target_chart_id, m_name, OBJPROP_LEVELWIDTH, i, width);
            ObjectSetInteger(target_chart_id, m_name, OBJPROP_LEVELCOLOR, i, clrlevel);
            ObjectSetInteger(target_chart_id, m_name, OBJPROP_LEVELSTYLE, i, style);
         }
         
         CopyCommonProperties(target_chart_id);
         
         return true;
      }
      
      return false;
   }
};
