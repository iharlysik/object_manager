//+------------------------------------------------------------------+
//|                                                  GraphCloner.mqh |
//|                                  Copyright 2026, Твой Никнейм    |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026"
#property strict

//====================================================================
// 1. БАЗОВЫЙ КЛАСС ДЛЯ ВСЕХ ГРАФИЧЕСКИХ ОБЪЕКТОВ
//====================================================================
class CGraphicObject {
protected:
   string   m_name;        // Имя объекта
   long     m_chart_id;    // ID исходного графика

   // Метод для копирования общих визуальных свойств (цвет, стиль, ширина)
   void CopyCommonProperties(long target_chart_id) {
      color clr = (color)ObjectGetInteger(m_chart_id, m_name, OBJPROP_COLOR);
      ENUM_LINE_STYLE style = (ENUM_LINE_STYLE)ObjectGetInteger(m_chart_id, m_name, OBJPROP_STYLE);
      int width = (int)ObjectGetInteger(m_chart_id, m_name, OBJPROP_WIDTH);
      bool back = (bool)ObjectGetInteger(m_chart_id, m_name, OBJPROP_BACK);
      
      ObjectSetInteger(target_chart_id, m_name, OBJPROP_COLOR, clr);
      ObjectSetInteger(target_chart_id, m_name, OBJPROP_STYLE, style);
      ObjectSetInteger(target_chart_id, m_name, OBJPROP_WIDTH, width);
      ObjectSetInteger(target_chart_id, m_name, OBJPROP_BACK, back);
   }

public:
   CGraphicObject(long chart_id, string name) : m_chart_id(chart_id), m_name(name) {}
   virtual ~CGraphicObject() {}

   // Чисто виртуальные методы, которые обязан реализовать каждый потомок
   virtual bool CopyToChart(long target_chart_id) = 0;
   virtual bool DeleteFromChart(long target_chart_id) = 0;
};

//====================================================================
// 2. НАСЛЕДНИК: ГОРИЗОНТАЛЬНАЯ ЛИНИЯ
//====================================================================
class CMyHLine : public CGraphicObject {
public:
   CMyHLine(long chart_id, string name) : CGraphicObject(chart_id, name) {}

   virtual bool CopyToChart(long target_chart_id) override {
      double price = ObjectGetDouble(m_chart_id, m_name, OBJPROP_PRICE, 0);
      
      if(ObjectCreate(target_chart_id, m_name, OBJ_HLINE, 0, 0, price)) {
         CopyCommonProperties(target_chart_id);
         ChartRedraw(target_chart_id);
         return true;
      }
      // Если объект уже существует, просто обновляем его координату цены
      else if(ObjectFind(target_chart_id, m_name) >= 0) {
         ObjectSetDouble(target_chart_id, m_name, OBJPROP_PRICE, 0, price);
         CopyCommonProperties(target_chart_id);
         ChartRedraw(target_chart_id);
         return true;
      }
      return false;
   }

   virtual bool DeleteFromChart(long target_chart_id) override {
      return ObjectDelete(target_chart_id, m_name);
   }
};

//====================================================================
// 3. НАСЛЕДНИК: ВЕРТИКАЛЬНАЯ ЛИНИЯ
//====================================================================
class CMyVLine : public CGraphicObject {
public:
   CMyVLine(long chart_id, string name) : CGraphicObject(chart_id, name) {}

   virtual bool CopyToChart(long target_chart_id) override {
      datetime time = (datetime)ObjectGetInteger(m_chart_id, m_name, OBJPROP_TIME, 0);
      
      if(ObjectCreate(target_chart_id, m_name, OBJ_VLINE, 0, time, 0)) {
         CopyCommonProperties(target_chart_id);
         ChartRedraw(target_chart_id);
         return true;
      }
      else if(ObjectFind(target_chart_id, m_name) >= 0) {
         ObjectSetInteger(target_chart_id, m_name, OBJPROP_TIME, 0, time);
         CopyCommonProperties(target_chart_id);
         ChartRedraw(target_chart_id);
         return true;
      }
      return false;
   }

   virtual bool DeleteFromChart(long target_chart_id) override {
      return ObjectDelete(target_chart_id, m_name);
   }
};

//====================================================================
// 4. НАСЛЕДНИК: ТРЕНДОВАЯ ЛИНИЯ
//====================================================================
class CMyTrend : public CGraphicObject {
public:
   CMyTrend(long chart_id, string name) : CGraphicObject(chart_id, name) {}

   virtual bool CopyToChart(long target_chart_id) override {
      datetime time1  = (datetime)ObjectGetInteger(m_chart_id, m_name, OBJPROP_TIME, 0);
      double   price1 = ObjectGetDouble(m_chart_id, m_name, OBJPROP_PRICE, 0);
      datetime time2  = (datetime)ObjectGetInteger(m_chart_id, m_name, OBJPROP_TIME, 1);
      double   price2 = ObjectGetDouble(m_chart_id, m_name, OBJPROP_PRICE, 1);
      bool     ray_left  = (bool)ObjectGetInteger(m_chart_id, m_name, OBJPROP_RAY_LEFT);
      bool     ray_right = (bool)ObjectGetInteger(m_chart_id, m_name, OBJPROP_RAY_RIGHT);

      if(ObjectCreate(target_chart_id, m_name, OBJ_TREND, 0, time1, price1, time2, price2) || ObjectFind(target_chart_id, m_name) >= 0) {
         ObjectSetInteger(target_chart_id, m_name, OBJPROP_TIME, 0, time1);
         ObjectSetDouble(target_chart_id, m_name, OBJPROP_PRICE, 0, price1);
         ObjectSetInteger(target_chart_id, m_name, OBJPROP_TIME, 1, time2);
         ObjectSetDouble(target_chart_id, m_name, OBJPROP_PRICE, 1, price2);
         ObjectSetInteger(target_chart_id, m_name, OBJPROP_RAY_LEFT, ray_left);
         ObjectSetInteger(target_chart_id, m_name, OBJPROP_RAY_RIGHT, ray_right);
         CopyCommonProperties(target_chart_id);
         ChartRedraw(target_chart_id);
         return true;
      }
      return false;
   }

   virtual bool DeleteFromChart(long target_chart_id) override {
      return ObjectDelete(target_chart_id, m_name);
   }
};

//====================================================================
// 5. НАСЛЕДНИК: ПРЯМОУГОЛЬНИК
//====================================================================
class CMyRectangle : public CGraphicObject {
public:
   CMyRectangle(long chart_id, string name) : CGraphicObject(chart_id, name) {}

   virtual bool CopyToChart(long target_chart_id) override {
      datetime time1  = (datetime)ObjectGetInteger(m_chart_id, m_name, OBJPROP_TIME, 0);
      double   price1 = ObjectGetDouble(m_chart_id, m_name, OBJPROP_PRICE, 0);
      datetime time2  = (datetime)ObjectGetInteger(m_chart_id, m_name, OBJPROP_TIME, 1);
      double   price2 = ObjectGetDouble(m_chart_id, m_name, OBJPROP_PRICE, 1);
      bool     fill   = (bool)ObjectGetInteger(m_chart_id, m_name, OBJPROP_FILL);

      if(ObjectCreate(target_chart_id, m_name, OBJ_RECTANGLE, 0, time1, price1, time2, price2) || ObjectFind(target_chart_id, m_name) >= 0) {
         ObjectSetInteger(target_chart_id, m_name, OBJPROP_TIME, 0, time1);
         ObjectSetDouble(target_chart_id, m_name, OBJPROP_PRICE, 0, price1);
         ObjectSetInteger(target_chart_id, m_name, OBJPROP_TIME, 1, time2);
         ObjectSetDouble(target_chart_id, m_name, OBJPROP_PRICE, 1, price2);
         ObjectSetInteger(target_chart_id, m_name, OBJPROP_FILL, fill);
         CopyCommonProperties(target_chart_id);
         ChartRedraw(target_chart_id);
         return true;
      }
      return false;
   }

   virtual bool DeleteFromChart(long target_chart_id) override {
      return ObjectDelete(target_chart_id, m_name);
   }
};

//====================================================================
// 6. НАСЛЕДНИК: УРОВНИ ФИБОНАЧЧИ
//====================================================================
class CMyFibo : public CGraphicObject {
public:
   CMyFibo(long chart_id, string name) : CGraphicObject(chart_id, name) {}

   virtual bool CopyToChart(long target_chart_id) override {
      datetime time1  = (datetime)ObjectGetInteger(m_chart_id, m_name, OBJPROP_TIME, 0);
      double   price1 = ObjectGetDouble(m_chart_id, m_name, OBJPROP_PRICE, 0);
      datetime time2  = (datetime)ObjectGetInteger(m_chart_id, m_name, OBJPROP_TIME, 1);
      double   price2 = ObjectGetDouble(m_chart_id, m_name, OBJPROP_PRICE, 1);

      if(ObjectCreate(target_chart_id, m_name, OBJ_FIBO, 0, time1, price1, time2, price2) || ObjectFind(target_chart_id, m_name) >= 0) {
         ObjectSetInteger(target_chart_id, m_name, OBJPROP_TIME, 0, time1);
         ObjectSetDouble(target_chart_id, m_name, OBJPROP_PRICE, 0, price1);
         ObjectSetInteger(target_chart_id, m_name, OBJPROP_TIME, 1, time2);
         ObjectSetDouble(target_chart_id, m_name, OBJPROP_PRICE, 1, price2);
         
         // Копируем уровни Фибоначчи и их описания
         int levels = (int)ObjectGetInteger(m_chart_id, m_name, OBJPROP_LEVELS);
         ObjectSetInteger(target_chart_id, m_name, OBJPROP_LEVELS, levels);
         
         for(int i = 0; i < levels; i++) {
            double value = ObjectGetDouble(m_chart_id, m_name, OBJPROP_LEVELVALUE, i);
            string desc  = ObjectGetString(m_chart_id, m_name, OBJPROP_LEVELTEXT, i);
            ObjectSetDouble(target_chart_id, m_name, OBJPROP_LEVELVALUE, i, value);
            ObjectSetString(target_chart_id, m_name, OBJPROP_LEVELTEXT, i, desc);
         }
         CopyCommonProperties(target_chart_id);
         ChartRedraw(target_chart_id);
         return true;
      }
      return false;
   }

   virtual bool DeleteFromChart(long target_chart_id) override {
      return ObjectDelete(target_chart_id, m_name);
   }
};

//====================================================================
// 7. УПРАВЛЯЮЩИЙ КЛАСС (ДВИЖОК СИНХРОНИЗАЦИИ)
//====================================================================
class CGraphClonerEngine {
private:
   // Внутренняя фабрика для создания нужного объекта по его типу
   CGraphicObject* CreateObject(long chart_id, string name, ENUM_OBJECT type) {
      switch(type) {
         case OBJ_HLINE:     return new CMyHLine(chart_id, name);
         case OBJ_VLINE:     return new CMyVLine(chart_id, name);
         case OBJ_TREND:     return new CMyTrend(chart_id, name);
         case OBJ_RECTANGLE: return new CMyRectangle(chart_id, name);
         case OBJ_FIBO:      return new CMyFibo(chart_id, name);
         default:            return NULL; // Игнорируем типы, которые пока не поддерживаем
      }
   }
   
public:
   CGraphClonerEngine() {}
   ~CGraphClonerEngine() {}

   // МЕТОД ДЛЯ КОПИРОВАНИЯ ИЛИ ОБНОВЛЕНИЯ ВЫДЕЛЕННЫХ ОБЪЕКТОВ
   void CopyOrUpdateSelected() {
      long current_chart = ChartID();
      string symbol = ChartSymbol();
      int total = ObjectsTotal(current_chart, 0, -1);
      
      for (int i = total - 1; i >= 0; i--) {
         string name = ObjectName(current_chart, i, 0, -1); // Проверяем, выделен ли объект пользователем
         
         if(ObjectGetInteger(current_chart, name, OBJPROP_SELECTED)) {
            ENUM_OBJECT type = (ENUM_OBJECT)ObjectGetInteger(current_chart, name, OBJPROP_TYPE);
            CGraphicObject *obj = CreateObject(current_chart, name, type);
            if(obj != NULL) {
               // Бежим по всем окнам терминала
               long target_chart = ChartFirst();
               while(target_chart >= 0) {
                  // Копируем только на другие окна ТОГО ЖЕ символа (например, GBPUSD)
                  if(target_chart != current_chart && ChartSymbol(target_chart) == symbol) {
                     obj.CopyToChart(target_chart);
                  }
                  
                  target_chart = ChartNext(target_chart);
               }
               
               delete obj; // Очищаем память
            }
         }
      }
   }

   // МЕТОД ДЛЯ УДАЛЕНИЯ ВЫДЕЛЕННЫХ ОБЪЕКТОВ НА ВСЕХ ГРАФИКАХ
   void DeleteSelected() {
      long current_chart = ChartID();
      string symbol = ChartSymbol();
      int total = ObjectsTotal(current_chart, 0, -1);
      for(int i = total - 1; i >= 0; i--) {
         string name = ObjectName(current_chart, i, 0, -1);
         if(ObjectGetInteger(current_chart, name, OBJPROP_SELECTED)) {
            ENUM_OBJECT type = (ENUM_OBJECT)ObjectGetInteger(current_chart, name, OBJPROP_TYPE);
            CGraphicObject *obj = CreateObject(current_chart, name, type);
            
            if(obj != NULL) {
               long target_chart = ChartFirst();
               
               while(target_chart >= 0) {
                  if(target_chart != current_chart && ChartSymbol(target_chart) == symbol) {
                     obj.DeleteFromChart(target_chart);
                  }
                  
                  target_chart = ChartNext(target_chart);
               }
               
               delete obj;
            }
            
            // В самом конце удаляем объект с текущего основного графика
            ObjectDelete(current_chart, name);
         }
      }
      
      ChartRedraw(current_chart);
   }
};