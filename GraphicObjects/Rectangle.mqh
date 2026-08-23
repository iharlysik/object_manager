#include "GraphicObject.mqh";



class Rectangle : public GraphicObject {
private:
   datetime m_time1;
   double m_price1;
   datetime m_time2;
   double m_price2;
   bool m_fill;

public:
   Rectangle(long curr_chart_id, string name) : GraphicObject(curr_chart_id, name) {
      m_time1 = (datetime)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_TIME, 0);
      m_price1 = ObjectGetDouble(m_curr_chart_id, m_name, OBJPROP_PRICE, 0);
      m_time2 = (datetime)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_TIME, 1);
      m_price2 = ObjectGetDouble(m_curr_chart_id, m_name, OBJPROP_PRICE, 1);
      m_fill = (bool)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_FILL);
   }

   virtual bool CopyToChart(long target_chart_id) override {
      if (ObjectCreate(target_chart_id, m_name, OBJ_RECTANGLE, 0, m_time1, m_price1, m_time2, m_price2)) {
         ObjectSetInteger(target_chart_id, m_name, OBJPROP_FILL, m_fill);
         
         ApplyCommonProperties(target_chart_id);
         
         return true;
      }
      
      return false;
   }
};
