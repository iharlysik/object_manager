#include <Controls\Dialog.mqh>;
#include <Controls\Button.mqh>;
#include "GraphSyncEngine.mqh";



class ManagerPanel : public CAppDialog {
   private:
      CButton m_clone_update_button;
      CButton m_delete_button;
      GraphSyncEngine m_engine;
      
      int m_button_height;
      int m_left_indent;
      int m_top_indent;

   public:
      ManagerPanel(void);
      ~ManagerPanel(void);
      
      bool Init(void);
      //virtual bool OnEvent(const int id, const long &lparam, const double &dparam, const string &sparam);
      
      void ChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam) {
         CAppDialog::ChartEvent(id, lparam, dparam, sparam);
         
         // 2. ОТЛОВЛИВАЕМ ПЕРЕМЕЩЕНИЕ ПО ИСТОРИИ
         //if (id == CHARTEVENT_CHART_CHANGE) {
            // Метод сам проверит, включен ли режим, и если надо — подвинет график 1М
            //m_engine.SyncChartPosition();
         //}
         
         if (id == CHARTEVENT_OBJECT_CREATE) {
            Print("CREATE");
            m_engine.Copy(sparam);
         }
         
         if (id == CHARTEVENT_OBJECT_CHANGE) { 
            Print("CHANGE");
         }
         
         if (id == CHARTEVENT_OBJECT_DELETE) {
            Print("DELETE");
            m_engine.Delete(sparam);
         }
         
         if (id == CHARTEVENT_OBJECT_DRAG) {
            Print("DRAG");
         }
      }

   private:
      bool CreateCloneUpdateButton(void);
      bool CreateDeleteButton(void);
};

ManagerPanel::ManagerPanel(void) : m_button_height(30),
                                     m_left_indent(10),
                                     m_top_indent(10) {
                                       //m_engine.SetSyncEnabled(true);
                                     }
                                     
ManagerPanel::~ManagerPanel(void) {}
/*
EVENT_MAP_BEGIN(ManagerPanel)
   ON_EVENT(ON_CLICK, m_clone_update_button, OnClickCloneUpdateButton)
   ON_EVENT(ON_CLICK, m_delete_button, OnClickDeleteButton)
EVENT_MAP_END(CAppDialog)
*/
bool ManagerPanel::Init(void) {
   int chart_width = (int)ChartGetInteger(0, CHART_WIDTH_IN_PIXELS, 0);
   int x2 = chart_width - 10;

   if (
      !Create(0, "Управление объектами", 0, x2 - 290, 30, x2, 150) ||
      !CreateCloneUpdateButton() ||
      !CreateDeleteButton()
   ) {
      return false;
   }
   
   Run();
   
   ChartSetInteger(m_chart_id, CHART_EVENT_OBJECT_CREATE, true);
   ChartSetInteger(m_chart_id, CHART_EVENT_OBJECT_DELETE, true);
   
   return true;
}

bool ManagerPanel::CreateCloneUpdateButton(void) {
   int x1 = m_left_indent;
   int y1 = m_top_indent;
   int x2 = Width() - x1 - 9;
   int y2 = y1 + m_button_height;

   if (!m_clone_update_button.Create(m_chart_id, m_name + "_clone_update_button", m_subwin, x1, y1, x2, y2)) {
      return false;
   }

   m_clone_update_button.Text("Коп. / Обн. выделенные");

   if (!Add(m_clone_update_button)) {
      return false;
   }

   return true;
}

bool ManagerPanel::CreateDeleteButton(void) {
   int x1 = m_left_indent;
   int y1 = (m_top_indent * 2) + m_button_height;
   int x2 = Width() - x1 - 9;
   int y2 = y1 + m_button_height;

   if (!m_delete_button.Create(m_chart_id, m_name + "_delete_button", m_subwin, x1, y1, x2, y2)) {
      return false;
   }

   m_delete_button.Text("Удалить выделенные");

   if (!Add(m_delete_button)) {
      return false;
   }

   return true;
}
