#include "GraphicObject.mqh";



class VLine : public GraphicObject {
private:
   datetime m_time;

public:
   VLine(long curr_chart_id, string name) : GraphicObject(curr_chart_id, name) {
      m_time = (datetime)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_TIME, 0);
   }

   virtual bool CopyToChart(long target_chart_id) override {
      if (ObjectCreate(target_chart_id, m_name, OBJ_VLINE, 0, m_time, 0)) {
         ApplyCommonProperties(target_chart_id);
         
         return true;
      }
      
      return false;
   }
   
   virtual void Drag(long target_chart_id) override {
      ObjectSetInteger(target_chart_id, m_name, OBJPROP_TIME, 0, m_time);
   }
};
