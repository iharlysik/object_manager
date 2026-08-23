#property version   "1.00"

#include "ChartRectangle.mqh"


// Имена объектов
const string TEXT_NAME  = "MovingPanel_Txt";

ChartRectangle SLRectangle("SLRectangle_Bg");

// Глобальные переменные для отслеживания состояния мыши
bool   isDragging = false;     // Нажата ли кнопка мыши на панели
int    dragStartX = 0;         // Начальная X-координата клика
int    dragStartY = 0;         // Начальная Y-координата клика

// Начальные смещения точек прямоугольника относительно места клика
int    offsetX1 = 0, offsetY1 = 0;
int    offsetX2 = 0, offsetY2 = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   // Обязательно включаем отслеживание перемещения мыши на графике
   ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, true);
   
   // Создаем начальную панель на текущих барах
   datetime time1 = iTime(_Symbol, PERIOD_CURRENT, 1);
   datetime time2 = iTime(_Symbol, PERIOD_CURRENT, 31);
   
   double price1 = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double price2 = price1 + 40 * _Point;

   // Создаем фон (ЗАПРЕЩАЕМ выделение, отправляем на задний план)
   if(SLRectangle.Create(time1, price1, time2, price2))
     {
      SLRectangle.Color(clrDarkSlateGray);
      SLRectangle.Fill(true);
      SLRectangle.Back(true);
      SLRectangle.Selectable(false);
     }

   // Создаем текст
   datetime textTime  = time1 + (time2 - time1) / 2;
   double   textPrice = price1 + (price2 - price1) / 2;

   if(ObjectCreate(0, TEXT_NAME, OBJ_TEXT, 0, textTime, textPrice))
     {
      ObjectSetString(0, TEXT_NAME, OBJPROP_TEXT, DoubleToString(price1, _Digits));
      ObjectSetInteger(0, TEXT_NAME, OBJPROP_COLOR, clrWhite);
      ObjectSetInteger(0, TEXT_NAME, OBJPROP_FONTSIZE, 14);
      ObjectSetInteger(0, TEXT_NAME, OBJPROP_ANCHOR, ANCHOR_CENTER);
      ObjectSetInteger(0, TEXT_NAME, OBJPROP_SELECTABLE, false);
     }

   ChartRedraw(0);
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   // Удаляем объекты при удалении робота с графика
   SLRectangle.Destroy();
   ObjectDelete(0, TEXT_NAME);
   ChartRedraw(0);
  }

//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
   // Обрабатываем движение мыши и клики
   if(id == CHARTEVENT_MOUSE_MOVE)
     {
      int mouseX = (int)lparam;          // Текущая координата X мыши в пикселях
      int mouseY = (int)dparam;          // Текущая координата Y мыши в пикселях
      uint mouseState = (uint)sparam;    // Состояние кнопок мыши
      
      // Проверяем, зажата ли левая кнопка мыши (флаг 1)
      bool isLeftButtonPressed = ((mouseState & 1) == 1);
      
      // 1. НАЧАЛО ПЕРЕТАСКИВАНИЯ: Кликнули на панель
      if(isLeftButtonPressed && !isDragging)
        {
         // Проверяем, находится ли курсор мыши в границах нашего прямоугольника
         datetime t1 = (datetime)ObjectGetInteger(0, PANEL_NAME, OBJPROP_TIME, 0);
         datetime t2 = (datetime)ObjectGetInteger(0, PANEL_NAME, OBJPROP_TIME, 1);
         double   p1 = ObjectGetDouble(0, PANEL_NAME, OBJPROP_PRICE, 0);
         double   p2 = ObjectGetDouble(0, PANEL_NAME, OBJPROP_PRICE, 1);
         
         int x1, y1, x2, y2;
         // Переводим координаты времени/цены панели в пиксели экрана для проверки
         if(ChartTimePriceToXY(0, 0, t1, p1, x1, y1) && ChartTimePriceToXY(0, 0, t2, p2, x2, y2))
           {
            int minX = MathMin(x1, x2);
            int maxX = MathMax(x1, x2);
            int minY = MathMin(y1, y2);
            int maxY = MathMax(y1, y2);
            
            // Если курсор внутри панели, захватываем её
            if(mouseX >= minX && mouseX <= maxX && mouseY >= minY && mouseY <= maxY)
              {
               ChartSetInteger(0, CHART_MOUSE_SCROLL, 0, false);
               isDragging = true;
               dragStartX = mouseX;
               dragStartY = mouseY;
               
               // Запоминаем смещение пикселей углов относительно точки клика
               offsetX1 = x1 - mouseX;   offsetY1 = y1 - mouseY;
               offsetX2 = x2 - mouseX;   offsetY2 = y2 - mouseY;
              }
           }
        }
      
      // 2. ПРОЦЕСС ПЕРЕТАСКИВАНИЯ: Мышь движется с зажатой кнопкой
      if(isDragging && isLeftButtonPressed)
        {
         // Вычисляем новые пиксельные координаты углов панели на основе движения мыши
         int newX1 = mouseX + offsetX1;
         int newY1 = mouseY + offsetY1;
         int newX2 = mouseX + offsetX2;
         int newY2 = mouseY + offsetY2;
         
         datetime newT1, newT2;
         double   newP1, newP2;
         int subwin = 0;
         
         // Конвертируем новые пиксели обратно в переменные времени и цены графика
         if(ChartXYToTimePrice(0, newX1, newY1, subwin, newT1, newP1) && 
            ChartXYToTimePrice(0, newX2, newY2, subwin, newT2, newP2))
           {
            // Обновляем позицию фона
            ObjectSetInteger(0, PANEL_NAME, OBJPROP_TIME, 0, newT1);
            ObjectSetDouble(0, PANEL_NAME, OBJPROP_PRICE, 0, newP1);
            ObjectSetInteger(0, PANEL_NAME, OBJPROP_TIME, 1, newT2);
            ObjectSetDouble(0, PANEL_NAME, OBJPROP_PRICE, 1, newP2);
            
            // Сразу же вычисляем центр для текста (Проблема 3 решена - синхронное движение)
            datetime newTextTime  = newT1 + (newT2 - newT1) / 2;
            double   newTextPrice = newP1 + (newP2 - newP1) / 2;
            
            ObjectSetInteger(0, TEXT_NAME, OBJPROP_TIME, 0, newTextTime);
            ObjectSetDouble(0, TEXT_NAME, OBJPROP_PRICE, 0, newTextPrice);
            ObjectSetString(0, TEXT_NAME, OBJPROP_TEXT, DoubleToString(newP1, _Digits));
            
            // Перерисовываем график на каждом шаге движения мыши
            ChartRedraw(0);
           }
        }
      
      // 3. КОНЕЦ ПЕРЕТАСКИВАНИЯ: Кнопку мыши отпустили
      if(!isLeftButtonPressed && isDragging)
        {
         ChartSetInteger(0, CHART_MOUSE_SCROLL, 0, true);
         isDragging = false;
        }
     }
  }
