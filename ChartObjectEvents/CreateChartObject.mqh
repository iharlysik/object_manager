#include "../GraphicObjects/GraphicObject.mqh";
#include "ChartObjectEvent.mqh";
#include "ChartObjectsFactory.mqh";



class CCreateChartObject : public CChartObjectEvent {
private:
   CChartObjectsFactory m_obj_factory;
   GraphicObject* m_obj;
   
public:
   CCreateChartObject(long curr_chart_id, string name) : CChartObjectEvent(curr_chart_id, name) {
      m_obj = m_obj_factory.Create(m_curr_chart_id, m_name, m_chart_object.Type());
   }
   
   ~CCreateChartObject() {
      delete m_obj;
   }

   bool Execute(const long target_chart_id) override {
      if (m_obj != NULL) {
         return m_obj.CopyToChart(target_chart_id);
      }
      
      return false;
   }
};
