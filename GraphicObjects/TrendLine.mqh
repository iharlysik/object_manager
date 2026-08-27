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
      m_time1 = (datetime)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_TIME, 0);
      m_price1 = ObjectGetDouble(m_curr_chart_id, m_name, OBJPROP_PRICE, 0);
      m_time2 = (datetime)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_TIME, 1);
      m_price2 = ObjectGetDouble(m_curr_chart_id, m_name, OBJPROP_PRICE, 1);
      m_ray_left  = (bool)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_RAY_LEFT);
      m_ray_right = (bool)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_RAY_RIGHT);
   }

   virtual bool CopyToChart(long target_chart_id) override {
      if (ObjectCreate(target_chart_id, m_name, OBJ_TREND, 0, m_time1, m_price1, m_time2, m_price2)) {
         ObjectSetInteger(target_chart_id, m_name, OBJPROP_RAY_LEFT, m_ray_left);
         ObjectSetInteger(target_chart_id, m_name, OBJPROP_RAY_RIGHT, m_ray_right);
         
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
