#include "GraphicObjects/GraphicObject.mqh";
#include "GraphicObjects/HLine.mqh";
#include "GraphicObjects/VLine.mqh";
#include "GraphicObjects/TrendLine.mqh";
#include "GraphicObjects/Rectangle.mqh";
#include "GraphicObjects/Fibo.mqh";



class GraphSyncEngine {
private:
   bool m_sync_enabled; // Флаг: включена ли синхронизация истории

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
   
   void ChartsRedraw() {
      string symbol = ChartSymbol();
      long redraw_chart = ChartFirst();
      
      while (redraw_chart >= 0) {
         if (ChartSymbol(redraw_chart) == symbol) {
            ChartRedraw(redraw_chart);
         }
         
         redraw_chart = ChartNext(redraw_chart);
      }
   }
   
public:
   GraphSyncEngine() : m_sync_enabled(false) {};
   ~GraphSyncEngine() {};
   
   void Copy(string obj_name) {
      long current_chart = ChartID();
      string symbol = ChartSymbol();
      
      ENUM_OBJECT type = (ENUM_OBJECT)ObjectGetInteger(current_chart, obj_name, OBJPROP_TYPE);
      GraphicObject *obj = CreateObject(current_chart, obj_name, type);
      
      if (obj != NULL) {
         long target_chart = ChartFirst();
         
         while (target_chart >= 0) {
            if (ChartSymbol(target_chart) == symbol && target_chart != current_chart) {
               obj.CopyToChart(target_chart);
               ChartRedraw(target_chart);
            }
            
            target_chart = ChartNext(target_chart);
         }
         
         delete obj; 
      }
   }
   
   void Delete(string obj_name) {
      long current_chart = ChartID();
      string symbol = ChartSymbol();
      long target_chart = ChartFirst();
            
      while (target_chart >= 0) {
         if ((ChartSymbol(target_chart) == symbol) && (target_chart != current_chart) && (ObjectFind(target_chart, obj_name) == 0)) {
            ObjectDelete(target_chart, obj_name);
            ChartRedraw(target_chart);
         }
         
         target_chart = ChartNext(target_chart);
      }
   }
   
   // Сеттер для переключения режима извне (из интерфейса)
   void SetSyncEnabled(bool enable) {
      m_sync_enabled = enable;
      
      // Если синхронизацию выключили, можно вернуть автоскролл назад (по желанию)
      if(!m_sync_enabled) {
         long current_chart = ChartID();
         string symbol = ChartSymbol();
         long target_chart = ChartFirst();
         while(target_chart >= 0) {
            if(target_chart != current_chart && ChartSymbol(target_chart) == symbol) {
               ChartSetInteger(target_chart, CHART_AUTOSCROLL, true); // Возвращаем автоскролл
               ChartRedraw(target_chart);
            }
            target_chart = ChartNext(target_chart);
         }
      }
   }
   
   bool IsSyncEnabled() const { return m_sync_enabled; }

   // МЕТОД ДЛЯ СИНХРОНИЗАЦИИ (Вызывается только если m_sync_enabled == true)
   void SyncChartPosition() {
      if(!m_sync_enabled) return; // Если чекбокс выключен — ничего не делаем

      long current_chart = ChartID();
      string symbol = ChartSymbol();
      
      long zoom = ChartGetInteger(current_chart, CHART_SCALE);
      int first_visible_bar = (int)ChartGetInteger(current_chart, CHART_FIRST_VISIBLE_BAR);
      datetime visible_time = iTime(symbol, _Period, first_visible_bar);
      
      long target_chart = ChartFirst();
      while(target_chart >= 0) {
         if(target_chart != current_chart && ChartSymbol(target_chart) == symbol) {
            
            // Жестко отключаем автоскролл на ведомом графике, пока включен чекбокс
            ChartSetInteger(target_chart, CHART_AUTOSCROLL, false);
            
            if(ChartGetInteger(target_chart, CHART_SCALE) != zoom) {
               ChartSetInteger(target_chart, CHART_SCALE, zoom);
            }
            
            int target_bar = iBarShift(symbol, ChartPeriod(target_chart), visible_time, false);
            ChartNavigate(target_chart, CHART_END, -target_bar);
            
            ChartRedraw(target_chart);
         }
         target_chart = ChartNext(target_chart);
      }
   }
};
