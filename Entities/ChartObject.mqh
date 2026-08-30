class CChartObject {
private:
   long m_chart_id;
   int m_sub_window;
   string m_name;

public:
   CChartObject() : m_chart_id(0),
                    m_sub_window(0) {}
   
   ~CChartObject() {}
   
   void Name(const string name) {
      m_name = name;
   }
   
   string Name() {
      return m_name;
   }
   
   void Id(const long chart_id) {
      m_chart_id = chart_id;
   }
   
   long Id() {
      return m_chart_id;
   }
   
   void SubWindow(const int sub_window) {
      m_sub_window = sub_window;
   }
   
   int SubWindow() {
      return m_sub_window;
   }
   
   bool ChangeName(const string name) {
      if (ObjectSetString(m_chart_id, m_name, OBJPROP_NAME, name)) {
         m_name = name;
         return true;
      }
      
      return false;
   }
   
   bool Delete() {
      return ObjectDelete(m_chart_id, m_name);
   }
   
   bool SetPoint(const int point, const datetime time, const double price) {
      return ObjectMove(m_chart_id, m_name, point, time, price);
   }
   
   datetime Time(const int point) {
      return (datetime)ObjectGetInteger(m_chart_id, m_name, OBJPROP_TIME, point);
   }
   
   bool Time(const int point, const datetime time) {
      return ObjectSetInteger(m_chart_id, m_name, OBJPROP_TIME, point, time);
   }
   
   double Price(const int point) {
      return ObjectGetDouble(m_chart_id, m_name, OBJPROP_PRICE, point);
   }
   
   bool Price(const int point, const double price) {
      return ObjectSetDouble(m_chart_id, m_name, OBJPROP_PRICE, point, price);
   }
   
   color Color() {
      return (color)ObjectGetInteger(m_chart_id, m_name, OBJPROP_COLOR);
   }
   
   bool Color(const color new_color) {
      return ObjectSetInteger(m_chart_id, m_name, OBJPROP_COLOR, new_color);
   }
   
   ENUM_LINE_STYLE Style() {
      return (ENUM_LINE_STYLE)ObjectGetInteger(m_chart_id, m_name, OBJPROP_STYLE);
   }
   
   bool Style(const ENUM_LINE_STYLE new_style) {
      return ObjectSetInteger(m_chart_id, m_name, OBJPROP_STYLE, new_style);
   }
   
   int Width() {
      return (int)ObjectGetInteger(m_chart_id, m_name, OBJPROP_WIDTH);
   }
   
   bool Width(const int new_width) {
      return ObjectSetInteger(m_chart_id, m_name, OBJPROP_WIDTH, new_width);
   }
   
   bool Background() {
      return (bool)ObjectGetInteger(m_chart_id, m_name, OBJPROP_BACK);
   }
   
   bool Background(const bool new_back) {
      return ObjectSetInteger(m_chart_id, m_name, OBJPROP_BACK, new_back);
   }
   
   bool Fill() {
      return (bool)ObjectGetInteger(m_chart_id, m_name, OBJPROP_FILL);
   }
   
   bool Fill(const bool new_fill) {
      return ObjectSetInteger(m_chart_id, m_name, OBJPROP_FILL, new_fill);
   }
   
   long Z_Order() {
      return ObjectGetInteger(m_chart_id, m_name, OBJPROP_ZORDER);
   }
   
   bool Z_Order(const long value) {
      return ObjectSetInteger(m_chart_id, m_name, OBJPROP_ZORDER, value);
   }
   
   bool Selected() {
      return (bool)ObjectGetInteger(m_chart_id, m_name, OBJPROP_SELECTED);
   }
   
   bool Selected(const bool new_sel) {
      return ObjectSetInteger(m_chart_id, m_name, OBJPROP_SELECTED, new_sel);
   }
   
   bool Selectable() {
      return (bool)ObjectGetInteger(m_chart_id, m_name, OBJPROP_SELECTABLE);
   }
   
   bool Selectable(const bool new_sel) {
      return ObjectSetInteger(m_chart_id, m_name, OBJPROP_SELECTABLE, new_sel);
   }
   
   string Description() {
      return ObjectGetString(m_chart_id, m_name, OBJPROP_TEXT);
   }
   
   bool Description(const string new_text) {
      string text = new_text;
      
      if (new_text == "") {
         text = " ";
      }
      
      return ObjectSetString(m_chart_id, m_name, OBJPROP_TEXT, text);
   }
   
   string Tooltip() {
      return ObjectGetString(m_chart_id, m_name, OBJPROP_TOOLTIP);
   }
   
   bool Tooltip(const string new_text) {
      string text = new_text;
      
      if (new_text == "") {
         text = " ";
      }
      
      return ObjectSetString(m_chart_id, m_name, OBJPROP_TOOLTIP, text);
   }
   
   int Timeframes() {
      return (int)ObjectGetInteger(m_chart_id, m_name, OBJPROP_TIMEFRAMES);
   }
   
   bool Timeframes(const int timeframes) {
      return ObjectSetInteger(m_chart_id, m_name, OBJPROP_TIMEFRAMES, timeframes);
   }
   
   datetime CreateTime() {
      return (datetime)ObjectGetInteger(m_chart_id, m_name, OBJPROP_CREATETIME);
   }
   
   int LevelsCount() {
      return (int)ObjectGetInteger(m_chart_id, m_name, OBJPROP_LEVELS);
   }
   
   bool LevelsCount(const int new_count) {
      return ObjectSetInteger(m_chart_id, m_name, OBJPROP_LEVELS, new_count);
   }
   
   color LevelColor(const int level) {
      if (level >= LevelsCount()) {
         return clrNONE;
      }
      
      return (color)ObjectGetInteger(m_chart_id, m_name, OBJPROP_LEVELCOLOR, level);
   }
   
   bool LevelColor(const int level, const color new_color) {
      if (level >= LevelsCount()) {
         return false;
      }
      
      return ObjectSetInteger(m_chart_id, m_name, OBJPROP_LEVELCOLOR, level, new_color);
   }
   
   ENUM_LINE_STYLE LevelStyle(const int level) {
      if (level >= LevelsCount()) {
         return WRONG_VALUE;
      }
      
      return (ENUM_LINE_STYLE)ObjectGetInteger(m_chart_id, m_name, OBJPROP_LEVELSTYLE, level);
   }
   
   bool LevelStyle(const int level, const ENUM_LINE_STYLE new_style) {
      if (level >= LevelsCount()) {
         return false;
      }
      
      return ObjectSetInteger(m_chart_id, m_name, OBJPROP_LEVELSTYLE, level, new_style);
   }
   
   int LevelWidth(const int level) {
      if (level >= LevelsCount()) {
         return -1;
      }
      
      return (int)ObjectGetInteger(m_chart_id, m_name, OBJPROP_LEVELWIDTH, level);
   }
   
   bool LevelWidth(const int level, const int new_width) {
      if (level >= LevelsCount()) {
         return false;
      }
      
      return ObjectSetInteger(m_chart_id, m_name, OBJPROP_LEVELWIDTH, level, new_width);
   }
   
   double LevelValue(const int level) {
      if (level >= LevelsCount()) {
         return EMPTY_VALUE;
      }
      
      return ObjectGetDouble(m_chart_id, m_name, OBJPROP_LEVELVALUE, level);
   }
   
   bool LevelValue(const int level,const double new_value) {
      if (level >= LevelsCount()) {
         return false;
      }
      
      return ObjectSetDouble(m_chart_id, m_name, OBJPROP_LEVELVALUE, level, new_value);
   }
   
   string LevelDescription(const int level) {
      if (level >= LevelsCount()) {
         return "";
      }
      
      return ObjectGetString(m_chart_id, m_name, OBJPROP_LEVELTEXT, level);
   }
   
   bool LevelDescription(const int level, const string new_text) {
      if (level >= LevelsCount()) {
         return false;
      }
      
      return ObjectSetString(m_chart_id, m_name, OBJPROP_LEVELTEXT, level, new_text);
   }
   
   long GetInteger(const ENUM_OBJECT_PROPERTY_INTEGER prop_id, const int modifier) {
      if (modifier == -1) {
         return ObjectGetInteger(m_chart_id, m_name, prop_id);
      }
      
      return ObjectGetInteger(m_chart_id, m_name, prop_id, modifier);
   }
   
   bool GetInteger(const ENUM_OBJECT_PROPERTY_INTEGER prop_id, const int modifier, long &value) {
      return ObjectGetInteger(m_chart_id, m_name, prop_id, modifier, value);
   }
   
   bool SetInteger(const ENUM_OBJECT_PROPERTY_INTEGER prop_id, const int modifier, const long value) {
      return ObjectSetInteger(m_chart_id, m_name, prop_id, modifier, value);
   }
   
   bool SetInteger(const ENUM_OBJECT_PROPERTY_INTEGER prop_id, const long value) {
      return ObjectSetInteger(m_chart_id, m_name, prop_id, value);
   }
   
   double GetDouble(const ENUM_OBJECT_PROPERTY_DOUBLE prop_id, const int modifier) {
      if (modifier == -1) {
         return ObjectGetDouble(m_chart_id, m_name, prop_id);
      }
         
      return ObjectGetDouble(m_chart_id, m_name, prop_id, modifier);
   }
   
   bool GetDouble(const ENUM_OBJECT_PROPERTY_DOUBLE prop_id, const int modifier, double &value) {
      return ObjectGetDouble(m_chart_id, m_name, prop_id, modifier, value);
   }
   
   bool SetDouble(const ENUM_OBJECT_PROPERTY_DOUBLE prop_id, const int modifier, const double value) {
      return ObjectSetDouble(m_chart_id, m_name, prop_id, modifier, value);
   }
   
   bool SetDouble(const ENUM_OBJECT_PROPERTY_DOUBLE prop_id, const double value) {
      return ObjectSetDouble(m_chart_id, m_name, prop_id, value);
   }
   
   string GetString(const ENUM_OBJECT_PROPERTY_STRING prop_id, const int modifier) {
      if (modifier == -1) {
         return(ObjectGetString(m_chart_id, m_name, prop_id));
      }
      
      return(ObjectGetString(m_chart_id, m_name, prop_id, modifier));
   }
   
   bool GetString(const ENUM_OBJECT_PROPERTY_STRING prop_id, const int modifier, string &value) {
      return ObjectGetString(m_chart_id, m_name, prop_id, modifier, value);
   }
   
   bool SetString(const ENUM_OBJECT_PROPERTY_STRING prop_id, const int modifier, const string value) {
      return ObjectSetString(m_chart_id, m_name, prop_id, modifier, value);
   }
   
   bool SetString(const ENUM_OBJECT_PROPERTY_STRING prop_id, const string value) {
      return ObjectSetString(m_chart_id, m_name, prop_id, value);
   }
   /*
   bool ShiftObject(const datetime d_time, const double d_price) {
      bool result = true;
      int  i;
      
      for (i = 0; i < m_num_points; i++) {
         result &= ShiftPoint(i, d_time, d_price);
      }
         
      return result;
   }
   
   bool ShiftPoint(const int point, const datetime d_time, const double d_price) {
      datetime time = (datetime)ObjectGetInteger(m_chart_id, m_name, OBJPROP_TIME, point);
      double   price = ObjectGetDouble(m_chart_id, m_name, OBJPROP_PRICE, point);
      
      return ObjectMove(m_chart_id, m_name, point, time + d_time, price + d_price);
   }
   */
};
