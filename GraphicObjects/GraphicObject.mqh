class GraphicObject {
protected:
   string m_name;        // Имя объекта
   long m_curr_chart_id; // ID исходного графика
   color m_clr;
   ENUM_LINE_STYLE m_style;
   int m_width;
   bool m_back;
   ENUM_TIMEFRAMES m_timeframes;

   void ApplyCommonProperties(long target_chart_id) {
      ObjectSetInteger(target_chart_id, m_name, OBJPROP_COLOR, m_clr);
      ObjectSetInteger(target_chart_id, m_name, OBJPROP_STYLE, m_style);
      ObjectSetInteger(target_chart_id, m_name, OBJPROP_WIDTH, m_width);
      ObjectSetInteger(target_chart_id, m_name, OBJPROP_BACK, m_back);
      ObjectSetInteger(target_chart_id, m_name, OBJPROP_TIMEFRAMES, m_timeframes);
      ObjectSetInteger(target_chart_id, m_name, OBJPROP_HIDDEN, false);
      ObjectSetInteger(target_chart_id, m_name, OBJPROP_SELECTABLE, true);
   }

public:
   GraphicObject(long curr_chart_id, string name) : m_curr_chart_id(curr_chart_id), m_name(name) {
      m_clr = (color)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_COLOR);
      m_style = (ENUM_LINE_STYLE)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_STYLE);
      m_width = (int)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_WIDTH);
      m_back = (bool)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_BACK);
      m_timeframes = (ENUM_TIMEFRAMES)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_TIMEFRAMES);
   }
   
   virtual ~GraphicObject() {}
   virtual bool CopyToChart(long target_chart_id) = 0;
   virtual void Drag(long target_chart_id) = 0;
   
   bool DeleteFromChart(long target_chart_id) {
      return ObjectDelete(target_chart_id, m_name);
   }
};
