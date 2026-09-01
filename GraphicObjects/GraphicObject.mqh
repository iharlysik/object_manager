#include "../Entities/ChartGraphicObject.mqh";



class GraphicObject {
protected:
   CChartGraphicObject m_chart_object;
   string m_name;
   long m_curr_chart_id;
   color m_clr;
   ENUM_LINE_STYLE m_style;
   int m_width;
   bool m_back;
   long m_timeframes;

   void ApplyCommonProperties() {
      m_chart_object.Color(m_clr);
      m_chart_object.Style(m_style);
      m_chart_object.Width(m_width);
      m_chart_object.Background(m_back);
      m_chart_object.Timeframes(m_timeframes);
      m_chart_object.Hidden(false);
      m_chart_object.Selectable(true);
   }

public:
   GraphicObject(long curr_chart_id, string name) : m_curr_chart_id(curr_chart_id), m_name(name) {
      m_chart_object.Name(name);
      m_chart_object.ChartId(curr_chart_id);
   
      m_clr = m_chart_object.Color();
      m_style = m_chart_object.Style();
      m_width = m_chart_object.Width();
      m_back = m_chart_object.Background();
      m_timeframes = m_chart_object.Timeframes();
   }
   
   virtual ~GraphicObject() {}
   
   virtual bool CopyToChart(long target_chart_id) = 0;
   virtual void Drag(long target_chart_id) = 0;
   virtual void Change(long target_chart_id) = 0;
   
   bool DeleteFromChart(long target_chart_id) {
      m_chart_object.ChartId(target_chart_id);
      return m_chart_object.Delete();
   }
};
