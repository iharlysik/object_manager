#include "GraphicObjects/GraphicObject.mqh";
#include "GraphicObjects/HLine.mqh";
#include "GraphicObjects/VLine.mqh";
#include "GraphicObjects/TrendLine.mqh";
#include "GraphicObjects/Rectangle.mqh";
#include "GraphicObjects/Fibo.mqh";



class GraphSyncEngine {
private:
   // Внутренняя фабрика для создания нужного объекта по его типу
   GraphicObject* CreateObject(long chart_id, string name, ENUM_OBJECT type) {
      switch(type) {
         case OBJ_HLINE:     return new HLine(chart_id, name);
         case OBJ_VLINE:     return new VLine(chart_id, name);
         case OBJ_TREND:     return new TrendLine(chart_id, name);
         case OBJ_RECTANGLE: return new Rectangle(chart_id, name);
         case OBJ_FIBO:      return new Fibo(chart_id, name);
         default:            return NULL; // Игнорируем типы, которые пока не поддерживаем
      }
   }
   
public:
   GraphSyncEngine() {};
   ~GraphSyncEngine() {};
   
   void GetSelectedObjects(long chart_id, GraphicObject* &selected[]) {
      int totals = ObjectsTotal(chart_id, 0, -1);
      
      for (int i = 0; i < totals; i++) {
         string name = ObjectName(chart_id, i, 0);
         bool is_selected = ObjectGetInteger(chart_id, name, OBJPROP_SELECTED);
         bool is_hidden = ObjectGetInteger(chart_id, name, OBJPROP_HIDDEN);
         
         if (is_selected && !is_hidden) {
            ENUM_OBJECT type = (ENUM_OBJECT)ObjectGetInteger(chart_id, name, OBJPROP_TYPE);
            
            selected.Push(CreateObject(chart_id, name, type));
         }
      }
   }
   
   void CopyOrUpdateSelected() {
      long current_chart = ChartID();
      string symbol = ChartSymbol();
      
      GraphicObject* selected[];
      GetSelectedObjects(current_chart, selected);
      
      long target_chart = ChartFirst();
      
      while (target_chart >= 0) {
         if (
               (ChartSymbol(target_chart) == symbol)
               && (target_chart != current_chart)
         ) {
            int size = ArraySize(selected);
            for (int i = 0; i < size; i++) {
               selected[i].CopyToChart(target_chart);
            }
            
            ChartRedraw(target_chart);
         }
         
         target_chart = ChartNext(target_chart);
      }
      
      int size = ArraySize(selected);      
      for (int i = 0; i < size; i++) {
         delete selected[i];
      }
   }
   
   void DeleteSelected() {
      string symbol = ChartSymbol();
      
      GraphicObject* selected[];
      GetSelectedObjects(ChartID(), selected);
      
      long target_chart = ChartFirst();
      
      while (target_chart >= 0) {
         if (ChartSymbol(target_chart) == symbol) {
            int size = ArraySize(selected);
            for (int i = 0; i < size; i++) {
               selected[i].DeleteFromChart(target_chart);
            }
            
            ChartRedraw(target_chart);
         }
         
         target_chart = ChartNext(target_chart);
      }
      
      int size = ArraySize(selected);      
      for (int i = 0; i < size; i++) {
         delete selected[i];
      }
   }
};
