#include "GraphicObject.mqh";



class HLine : public GraphicObject {
private:
   double m_price;

public:
   HLine(long curr_chart_id, string name) : GraphicObject(curr_chart_id, name) {
      m_price = ObjectGetDouble(m_curr_chart_id, m_name, OBJPROP_PRICE, 0);
   }

   virtual bool CopyToChart(long target_chart_id) override {
      if (ObjectCreate(target_chart_id, m_name, OBJ_HLINE, 0, 0, m_price)) {
         ApplyCommonProperties(target_chart_id);
         
         return true;
      }
      
      return false;
   }
   
   virtual void Drag(long target_chart_id) override {
      ObjectSetDouble(target_chart_id, m_name, OBJPROP_PRICE, 0, m_price);
   }
};
