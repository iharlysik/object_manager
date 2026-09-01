class CChartGraphicObject {
private:
   long m_chart_id;
   int m_sub_window;
   string m_name;
   int m_num_points;

public:
   CChartGraphicObject() : m_chart_id(0),
                    m_sub_window(0) {}
   
   ~CChartGraphicObject() {}
   
   void Name(const string name) {
      m_name = name;
   }
   
   string Name() {
      return m_name;
   }
   
   void ChartId(const long chart_id) {
      m_chart_id = chart_id;
   }
   
   long ChartId() {
      return m_chart_id;
   }
   
   void SubWindow(const int sub_window) {
      m_sub_window = sub_window;
   }
   
   int SubWindow() {
      return m_sub_window;
   }
   
   int NumPoints() {
      return m_num_points;
   }
   
   void NumPoints(const int num_points) {
      m_num_points = num_points;
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
      if (point >= m_num_points) {
         return false;
      }
   
      return ObjectMove(m_chart_id, m_name, point, time, price);
   }
   
   datetime Time(const int point) {
      if (point >= m_num_points) {
         return 0;
      }
   
      return (datetime)ObjectGetInteger(m_chart_id, m_name, OBJPROP_TIME, point);
   }
   
   bool Time(const int point, const datetime time) {
      if (point >= m_num_points) {
         return false;
      }
   
      return ObjectSetInteger(m_chart_id, m_name, OBJPROP_TIME, point, time);
   }
   
   double Price(const int point) {
      if (point >= m_num_points) {
         return EMPTY_VALUE;
      }
   
      return ObjectGetDouble(m_chart_id, m_name, OBJPROP_PRICE, point);
   }
   
   bool Price(const int point, const double price) {
      if (point >= m_num_points) {
         return false;
      }
   
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
   
   bool Hidden() {
      return (bool)ObjectGetInteger(m_chart_id, m_name, OBJPROP_HIDDEN);
   }
   
   bool Hidden(const bool new_hidden) {
      return ObjectSetInteger(m_chart_id, m_name, OBJPROP_HIDDEN, new_hidden);
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
   
   ENUM_OBJECT Type() {
      return (ENUM_OBJECT)ObjectGetInteger(m_chart_id, m_name, OBJPROP_TYPE);
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
   
   long Timeframes() {
      return (long)ObjectGetInteger(m_chart_id, m_name, OBJPROP_TIMEFRAMES);
   }
   
   bool Timeframes(const long timeframes) {
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
   
   int FontSize() {
      return (int)ObjectGetInteger(m_chart_id, m_name, OBJPROP_FONTSIZE);
   }
   
   bool FontSize(const int new_size) {
      return ObjectSetInteger(m_chart_id, m_name, OBJPROP_FONTSIZE, new_size);
   }
   
   bool RayLeft() {
      return (bool)ObjectGetInteger(m_chart_id, m_name, OBJPROP_RAY_LEFT);
   }
   
   bool RayLeft(const bool is_ray) {
      return ObjectSetInteger(m_chart_id, m_name, OBJPROP_RAY_LEFT, is_ray);
   }
   
   bool RayRight() {
      return (bool)ObjectGetInteger(m_chart_id, m_name, OBJPROP_RAY_RIGHT);
   }
   
   bool RayRight(const bool is_ray) {
      return ObjectSetInteger(m_chart_id, m_name, OBJPROP_RAY_RIGHT, is_ray);
   }
   
   bool Ray() {
      return (bool)ObjectGetInteger(m_chart_id, m_name, OBJPROP_RAY);
   }
   
   bool Ray(const bool is_ray) {
      return ObjectSetInteger(m_chart_id, m_name, OBJPROP_RAY, is_ray);
   }
   
   bool Ellipse() {
      return (bool)ObjectGetInteger(m_chart_id, m_name, OBJPROP_ELLIPSE);
   }
   
   bool Ellipse(const bool is_ellipse) {
      return ObjectSetInteger(m_chart_id, m_name, OBJPROP_ELLIPSE, is_ellipse);
   }
   
   int XDistance() {
      return (int)ObjectGetInteger(m_chart_id, m_name, OBJPROP_XDISTANCE);
   }
   
   bool XDistance(const int new_distance) {
      return ObjectSetInteger(m_chart_id, m_name, OBJPROP_XDISTANCE, new_distance);
   }
   
   int YDistance() {
      return (int)ObjectGetInteger(m_chart_id, m_name, OBJPROP_YDISTANCE);
   }
   
   bool YDistance(const int new_distance) {
      return ObjectSetInteger(m_chart_id, m_name, OBJPROP_YDISTANCE, new_distance);
   }
   
   ENUM_GANN_DIRECTION GannDirection() {
      return (ENUM_GANN_DIRECTION)ObjectGetInteger(m_chart_id, m_name, OBJPROP_DIRECTION);
   }
   
   bool GannDirection(const ENUM_GANN_DIRECTION new_direction) {
      return ObjectSetInteger(m_chart_id, m_name, OBJPROP_DIRECTION, new_direction);
   }
   
   ENUM_ELLIOT_WAVE_DEGREE ElliotWaveDegree() {
      return (ENUM_ELLIOT_WAVE_DEGREE)ObjectGetInteger(m_chart_id, m_name, OBJPROP_DEGREE);
   }
   
   bool ElliotWaveDegree(const ENUM_ELLIOT_WAVE_DEGREE new_degree) {
      return ObjectSetInteger(m_chart_id, m_name, OBJPROP_DEGREE, new_degree);
   }
   
   bool ElliotDrawLines() {
      return (bool)ObjectGetInteger(m_chart_id, m_name, OBJPROP_DRAWLINES);
   }
   
   bool ElliotDrawLines(const bool new_drawlines) {
      return ObjectSetInteger(m_chart_id, m_name, OBJPROP_DRAWLINES, new_drawlines);
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
   
   bool ShiftObject(const datetime d_time, const double d_price) {
      bool result = true;
      int  i;
      
      for (i = 0; i < m_num_points; i++) {
         result &= ShiftPoint(i, d_time, d_price);
      }
         
      return result;
   }
   
   bool ShiftPoint(const int point, const datetime d_time, const double d_price) {   
      if (point >= m_num_points) {
         return false;
      }
   
      datetime time = (datetime)ObjectGetInteger(m_chart_id, m_name, OBJPROP_TIME, point);
      double   price = ObjectGetDouble(m_chart_id, m_name, OBJPROP_PRICE, point);
      
      return ObjectMove(m_chart_id, m_name, point, time + d_time, price + d_price);
   }
};
