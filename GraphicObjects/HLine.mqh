#include "GraphicObject.mqh";



class HLine : public GraphicObject {
private:
   double m_price;

public:
   HLine(long curr_chart_id, string name) : GraphicObject(curr_chart_id, name) {
      m_chart_object.NumPoints(1);
      m_price = m_chart_object.Price(0);
   }

   virtual bool CopyToChart(long target_chart_id) override {
      if (ObjectCreate(target_chart_id, m_name, OBJ_HLINE, 0, 0, m_price)) {
         m_chart_object.ChartId(target_chart_id);
         ApplyCommonProperties();
         
         return true;
      }
      
      return false;
   }
   
   virtual void Drag(long target_chart_id) override {
      m_chart_object.ChartId(target_chart_id);
      m_chart_object.Price(0, m_price);
   }
   
   virtual void Change(long target_chart_id) override {
      m_chart_object.ChartId(target_chart_id);
      m_chart_object.Price(0, m_price);
      ApplyCommonProperties();
   }
};
