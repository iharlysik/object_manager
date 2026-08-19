#include "GraphicObject.mqh";



class VLine : public GraphicObject {
public:
   VLine(long chart_id, string name) : GraphicObject(chart_id, name) {}

   virtual bool CopyToChart(long target_chart_id) override {
      datetime time = (datetime)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_TIME, 0);
      
      if (ObjectCreate(target_chart_id, m_name, OBJ_VLINE, 0, time, 0)) {
         CopyCommonProperties(target_chart_id);
         
         return true;
      }
      
      return false;
   }
};
