#include "ChartObjectEvents/CreateChartObject.mqh";
#include "ChartObjectEvents/DragChartObject.mqh";
#include "ChartObjectEvents/ChangeChartObject.mqh";



class GraphSyncEngine {
private:
   bool m_sync_enabled;
   long m_current_chart;
   string m_symbol;
   
   void ChartsRedraw() {
      long redraw_chart = ChartFirst();
      
      while (redraw_chart >= 0) {
         if (ChartSymbol(redraw_chart) == m_symbol) {
            ChartRedraw(redraw_chart);
         }
         
         redraw_chart = ChartNext(redraw_chart);
      }
   }
   
public:
   GraphSyncEngine() : m_sync_enabled(false) {
      m_current_chart = ChartID();
      m_symbol = ChartSymbol();
   };
   
   ~GraphSyncEngine() {};
   
   void Copy(string obj_name) {
      CCreateChartObject create_obj(m_current_chart, obj_name);
      long target_chart = ChartFirst();
      
      while (target_chart >= 0) {
         if (ChartSymbol(target_chart) == m_symbol && target_chart != m_current_chart) {
            if (create_obj.Execute(target_chart)) {
               ChartRedraw(target_chart);
            }
         }
         
         target_chart = ChartNext(target_chart);
      }
   }
   
   void Drag(string obj_name) {
      CDragChartObject drag_obj(m_current_chart, obj_name);
      long target_chart = ChartFirst(); 
            
      while (target_chart >= 0) {
         if ((ChartSymbol(target_chart) == m_symbol) && (target_chart != m_current_chart) && (ObjectFind(target_chart, obj_name) == 0)) {
            if (drag_obj.Execute(target_chart)) {
               ChartRedraw(target_chart);
            }
         }
         
         target_chart = ChartNext(target_chart);
      }
   }
   
   void Change(string obj_name) {
      CChangeChartObject change_obj(m_current_chart, obj_name);
      long target_chart = ChartFirst(); 
            
      while (target_chart >= 0) {
         if ((ChartSymbol(target_chart) == m_symbol) && (target_chart != m_current_chart) && (ObjectFind(target_chart, obj_name) == 0)) {
            if (change_obj.Execute(target_chart)) {
               ChartRedraw(target_chart);
            }
         }
         
         target_chart = ChartNext(target_chart);
      }
   }
   
   void Delete(string obj_name) {
      long target_chart = ChartFirst(); 
            
      while (target_chart >= 0) {
         if ((ChartSymbol(target_chart) == m_symbol) && (target_chart != m_current_chart) && (ObjectFind(target_chart, obj_name) == 0)) {
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
      if (!m_sync_enabled) {
         long target_chart = ChartFirst();
         while (target_chart >= 0) {
            if (target_chart != m_current_chart && ChartSymbol(target_chart) == m_symbol) {
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
      
      long zoom = ChartGetInteger(m_current_chart, CHART_SCALE);
      int first_visible_bar = (int)ChartGetInteger(m_current_chart, CHART_FIRST_VISIBLE_BAR);
      datetime visible_time = iTime(m_symbol, _Period, first_visible_bar);
      
      long target_chart = ChartFirst();
      while(target_chart >= 0) {
         if(target_chart != m_current_chart && ChartSymbol(target_chart) == m_symbol) {
            
            // Жестко отключаем автоскролл на ведомом графике, пока включен чекбокс
            ChartSetInteger(target_chart, CHART_AUTOSCROLL, false);
            
            if(ChartGetInteger(target_chart, CHART_SCALE) != zoom) {
               ChartSetInteger(target_chart, CHART_SCALE, zoom);
            }
            
            int target_bar = iBarShift(m_symbol, ChartPeriod(target_chart), visible_time, false);
            ChartNavigate(target_chart, CHART_END, -target_bar);
            
            ChartRedraw(target_chart);
         }
         target_chart = ChartNext(target_chart);
      }
   }
};
