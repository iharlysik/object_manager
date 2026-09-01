#include "GraphicObject.mqh";



class Rectangle : public GraphicObject {
private:
   datetime m_time1;
   double m_price1;
   datetime m_time2;
   double m_price2;
   bool m_fill;

public:
   Rectangle(long curr_chart_id, string name) : GraphicObject(curr_chart_id, name) {
      m_chart_object.NumPoints(2);
      
      m_time1 = m_chart_object.Time(0);
      m_price1 = m_chart_object.Price(0);
      m_time2 = m_chart_object.Time(1);
      m_price2 = m_chart_object.Price(1);
      m_fill = m_chart_object.Fill();
   }

   virtual bool CopyToChart(long target_chart_id) override {
      if (ObjectCreate(target_chart_id, m_name, OBJ_RECTANGLE, 0, m_time1, m_price1, m_time2, m_price2)) {
         m_chart_object.ChartId(target_chart_id);
         
         m_chart_object.Fill(m_fill);
         
         ApplyCommonProperties();
         
         return true;
      }
      
      return false;
   }
   
   virtual void Drag(long target_chart_id) override {
      m_chart_object.ChartId(target_chart_id);
      m_chart_object.SetPoint(0, m_time1, m_price1);
      m_chart_object.SetPoint(1, m_time2, m_price2);
   }
   
   virtual void Change(long target_chart_id) override {
      m_chart_object.ChartId(target_chart_id);
      
      m_chart_object.Fill(m_fill);
      m_chart_object.SetPoint(0, m_time1, m_price1);
      m_chart_object.SetPoint(1, m_time2, m_price2);
      
      ApplyCommonProperties();
   }
};
