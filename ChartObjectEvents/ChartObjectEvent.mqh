#include "../Entities/ChartGraphicObject.mqh";



class CChartObjectEvent {
protected:
   long m_curr_chart_id;
   string m_name;
   CChartGraphicObject m_chart_object;

public:
   CChartObjectEvent(long curr_chart_id, string name) : m_curr_chart_id(curr_chart_id), m_name(name) {
      m_chart_object.ChartId(curr_chart_id);
      m_chart_object.Name(name);
   }
   
   virtual ~CChartObjectEvent() {}

   virtual bool Execute(const long target_chart_id) = 0;
};
