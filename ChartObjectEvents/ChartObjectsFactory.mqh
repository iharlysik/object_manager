#include "../GraphicObjects/GraphicObject.mqh";
#include "../GraphicObjects/HLine.mqh";
#include "../GraphicObjects/VLine.mqh";
#include "../GraphicObjects/TrendLine.mqh";
#include "../GraphicObjects/Rectangle.mqh";
#include "../GraphicObjects/Fibo.mqh";



class CChartObjectsFactory {
public:
   GraphicObject* Create(long chart_id, string name, ENUM_OBJECT type) {
      switch(type) {
         case OBJ_HLINE:     return new HLine(chart_id, name);
         case OBJ_VLINE:     return new VLine(chart_id, name);
         case OBJ_TREND:     return new TrendLine(chart_id, name);
         case OBJ_RECTANGLE: return new Rectangle(chart_id, name);
         case OBJ_FIBO:      return new Fibo(chart_id, name);
         default:            return NULL; // Игнорируем типы, которые пока не поддерживаем
      }
   }
};
