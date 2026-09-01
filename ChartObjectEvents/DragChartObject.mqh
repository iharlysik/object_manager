#include "../GraphicObjects/GraphicObject.mqh";
#include "ChartObjectEvent.mqh";
#include "ChartObjectsFactory.mqh";



class CDragChartObject : public CChartObjectEvent {
private:
   CChartObjectsFactory m_obj_factory;
   GraphicObject* m_obj;
   
public:
   CDragChartObject(long curr_chart_id, string name) : CChartObjectEvent(curr_chart_id, name) {
      m_obj = m_obj_factory.Create(m_curr_chart_id, m_name, m_chart_object.Type());
   }
   
   ~CDragChartObject() {
      delete m_obj;
   }

   bool Execute(const long target_chart_id) override {
      if (m_obj != NULL) {
         m_obj.Drag(target_chart_id);
         return true;
      }
      
      return false;
   }
};
