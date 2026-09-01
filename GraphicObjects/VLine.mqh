#include "GraphicObject.mqh";



class VLine : public GraphicObject {
private:
   datetime m_time;

public:
   VLine(long curr_chart_id, string name) : GraphicObject(curr_chart_id, name) {
      m_chart_object.NumPoints(1);
      m_time = m_chart_object.Time(0);
   }

   virtual bool CopyToChart(long target_chart_id) override {
      if (ObjectCreate(target_chart_id, m_name, OBJ_VLINE, 0, m_time, 0)) {
         m_chart_object.ChartId(target_chart_id);
         ApplyCommonProperties();
         
         return true;
      }
      
      return false;
   }
   
   virtual void Drag(long target_chart_id) override {
      m_chart_object.ChartId(target_chart_id);
      m_chart_object.Time(0, m_time);
   }
   
   virtual void Change(long target_chart_id) override {
      m_chart_object.ChartId(target_chart_id);
      m_chart_object.Time(0, m_time);
      ApplyCommonProperties();
   }
};
