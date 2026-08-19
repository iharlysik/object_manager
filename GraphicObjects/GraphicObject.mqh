class GraphicObject {
protected:
   string m_name;      // Имя объекта
   long m_curr_chart_id;    // ID исходного графика

   // Метод для копирования общих визуальных свойств (цвет, стиль, ширина)
   void CopyCommonProperties(long target_chart_id) {
      color clr = (color)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_COLOR);
      ENUM_LINE_STYLE style = (ENUM_LINE_STYLE)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_STYLE);
      int width = (int)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_WIDTH);
      bool back = (bool)ObjectGetInteger(m_curr_chart_id, m_name, OBJPROP_BACK);
      
      ObjectSetInteger(target_chart_id, m_name, OBJPROP_COLOR, clr);
      ObjectSetInteger(target_chart_id, m_name, OBJPROP_STYLE, style);
      ObjectSetInteger(target_chart_id, m_name, OBJPROP_WIDTH, width);
      ObjectSetInteger(target_chart_id, m_name, OBJPROP_BACK, back);
   }

public:
   GraphicObject(long chart_id, string name) : m_curr_chart_id(chart_id), m_name(name) {}
   virtual ~GraphicObject() {}

   virtual bool CopyToChart(long target_chart_id) = 0;
   
   bool DeleteFromChart(long target_chart_id) {
      return ObjectDelete(target_chart_id, m_name);
   }
};
