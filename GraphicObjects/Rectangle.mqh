#include "GraphicObject.mqh";



class Rectangle : public GraphicObject {
public:
   Rectangle(long chart_id, string name) : GraphicObject(chart_id, name) {}

   virtual bool CopyToChart(long target_chart_id) override {
      datetime time1  = (datetime)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_TIME, 0);
      double   price1 = ObjectGetDouble(m_curr_chart_id, m_name, OBJPROP_PRICE, 0);
      datetime time2  = (datetime)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_TIME, 1);
      double   price2 = ObjectGetDouble(m_curr_chart_id, m_name, OBJPROP_PRICE, 1);
      bool     fill   = (bool)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_FILL);

      if (ObjectCreate(target_chart_id, m_name, OBJ_RECTANGLE, 0, time1, price1, time2, price2)) {
         ObjectSetInteger(target_chart_id, m_name, OBJPROP_TIME, 0, time1);
         ObjectSetDouble(target_chart_id, m_name, OBJPROP_PRICE, 0, price1);
         ObjectSetInteger(target_chart_id, m_name, OBJPROP_TIME, 1, time2);
         ObjectSetDouble(target_chart_id, m_name, OBJPROP_PRICE, 1, price2);
         ObjectSetInteger(target_chart_id, m_name, OBJPROP_FILL, fill);
         
         CopyCommonProperties(target_chart_id);
         
         return true;
      }
      
      return false;
   }
};
