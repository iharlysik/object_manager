#include "GraphicObject.mqh";



class HLine : public GraphicObject {
public:
   HLine(long chart_id, string name) : GraphicObject(chart_id, name) {}

   virtual bool CopyToChart(long target_chart_id) override {
      double price = ObjectGetDouble(m_curr_chart_id, m_name, OBJPROP_PRICE, 0);
      
      if (ObjectCreate(target_chart_id, m_name, OBJ_HLINE, 0, 0, price)) {
         CopyCommonProperties(target_chart_id);
         
         return true;
      }
      
      return false;
   }
};
