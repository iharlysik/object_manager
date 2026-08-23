#define CURR_CHART_ID 0

ENUM_TIMEFRAMES CURRENT_CHART_PERIOD = _Period;

struct ObjectCoordinates {
   datetime datetime1;
   double price1;
   datetime datetime2;
   double price2;
};
   

void FindSelectedObjectsAndCloneOrUpdate(void) {
   string obj_names[];
   GetSelectedObjectsName(obj_names);
   
   int size = ArraySize(obj_names);
   
   for (int i = 0; i < size; i++) {
      CloneOrUpdateSelectedObjects(obj_names[i]);
   }
}

void CloneOrUpdateSelectedObjects(string obj_name) {
   long chart_id = ChartFirst();
   
   while (chart_id >= 0) {
      string chart_symbol = ChartSymbol(chart_id);
      ENUM_TIMEFRAMES chart_period = ChartPeriod(chart_id);
      
      if ((chart_symbol == _Symbol) && (chart_period != CURRENT_CHART_PERIOD)) {
         ENUM_OBJECT obj_type = (ENUM_OBJECT)ObjectGetInteger(CURR_CHART_ID, obj_name, OBJPROP_TYPE);
         ObjectCoordinates coordinates;
         GetObjectCoordinates(obj_name, coordinates);
      
         switch (obj_type) {
            case OBJ_VLINE:
               CloneVLine(chart_id, obj_name, coordinates);
               break;
            case OBJ_HLINE:
               CloneHLine(chart_id, obj_name, coordinates);
               break;
            case OBJ_TREND:
               CloneTrend(chart_id, obj_name, coordinates);
               break;
            case OBJ_RECTANGLE:
               CloneRectangle(chart_id, obj_name, coordinates);
               break;
            // TODO реализовать код, глубокого копирования уровней фиббоначи
            //case OBJ_FIBO:
            //  CloneFibo(chart_id, obj_name, coordinates);
            //  break;
         }
         
         ChartRedraw(chart_id);
      }
         
      chart_id = ChartNext(chart_id);
   }
}

void FindSelectedObjectsAndDelete(void) {
   string obj_names[];
   GetSelectedObjectsName(obj_names);
   
   int size = ArraySize(obj_names);
   
   for (int i = 0; i < size; i++) {
      DeleteSelectedObjects(obj_names[i]);
   }
}

void DeleteSelectedObjects(string obj_name) {
   long chart_id = ChartFirst();
   
   while (chart_id >= 0) {
      string chart_symbol = ChartSymbol(chart_id);
      
      if (chart_symbol == _Symbol) {
         ObjectDelete(chart_id, obj_name);
         ChartRedraw(chart_id);
      }
         
      chart_id = ChartNext(chart_id);
   }
}

void GetSelectedObjectsName(string &obj_names[]) {
   int totals = ObjectsTotal(CURR_CHART_ID, 0);
   
   for (int i = 0; i < totals; i++) {
      string obj_name = ObjectName(CURR_CHART_ID, i, 0);
      bool is_hidden = ObjectGetInteger(CURR_CHART_ID, obj_name, OBJPROP_HIDDEN);
      bool is_selected = ObjectGetInteger(CURR_CHART_ID, obj_name, OBJPROP_SELECTED);
      
      if (!is_hidden && is_selected) {
         obj_names.Push(obj_name);
      }
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloneVLine(long chart_id, string obj_name, ObjectCoordinates &coordinates) {
   if (ObjectCreate(chart_id, obj_name, OBJ_VLINE, 0, coordinates.datetime1, 0)) {
      CloneBaseObjectProps(chart_id, obj_name);
      CloneRay(chart_id, obj_name);
   }
}

void CloneHLine(long chart_id, string obj_name, ObjectCoordinates &coordinates) {
   if (ObjectCreate(chart_id, obj_name, OBJ_HLINE, 0, 0, coordinates.price1)) {
      CloneBaseObjectProps(chart_id, obj_name);
   }
}

void CloneTrend(long chart_id, string obj_name, ObjectCoordinates &coordinates) {
   if (ObjectCreate(chart_id, obj_name, OBJ_TREND, 0, coordinates.datetime1, coordinates.price1, coordinates.datetime2, coordinates.price2)) {
      CloneBaseObjectProps(chart_id, obj_name);
      CloneRayLeft(chart_id, obj_name);
      CloneRayRight(chart_id, obj_name);
   }
}

void CloneRectangle(long chart_id, string obj_name, ObjectCoordinates &coordinates) {
   if (ObjectCreate(chart_id, obj_name, OBJ_RECTANGLE, 0, coordinates.datetime1, coordinates.price1, coordinates.datetime2, coordinates.price2)) {
      CloneBaseObjectProps(chart_id, obj_name);
      CloneFill(chart_id, obj_name);
   }
}

void CloneFibo(long chart_id, string obj_name, ObjectCoordinates &coordinates) {
   if (ObjectCreate(chart_id, obj_name, OBJ_FIBO, 0, coordinates.datetime1, coordinates.price1, coordinates.datetime2, coordinates.price2)) {
      CloneBaseObjectProps(chart_id, obj_name);
      CloneRayLeft(chart_id, obj_name);
      CloneRayRight(chart_id, obj_name);
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GetObjectCoordinates(string obj_name, ObjectCoordinates &coordinates) {
   coordinates.datetime1 = GetObjectTime(obj_name, 0);
   coordinates.price1 = GetObjectPrice(obj_name, 0);
   coordinates.datetime2 = GetObjectTime(obj_name, 1);
   coordinates.price2 = GetObjectPrice(obj_name, 1);
}

datetime GetObjectTime(string obj_name, int point) {
   return (datetime)ObjectGetInteger(CURR_CHART_ID, obj_name, OBJPROP_TIME, point);
}

double GetObjectPrice(string obj_name, int point) {
   double price = ObjectGetDouble(CURR_CHART_ID, obj_name, OBJPROP_PRICE, point);
   return NormalizeDouble(price, _Digits);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloneColor(long chart_id, string obj_name) {
   color clr = (color)ObjectGetInteger(CURR_CHART_ID, obj_name, OBJPROP_COLOR);
   ObjectSetInteger(chart_id, obj_name, OBJPROP_COLOR, clr);
}

void CloneStyle(long chart_id, string obj_name) {
   ENUM_LINE_STYLE style = (ENUM_LINE_STYLE)ObjectGetInteger(CURR_CHART_ID, obj_name, OBJPROP_STYLE);
   ObjectSetInteger(chart_id, obj_name, OBJPROP_STYLE, style);
}

void CloneWidth(long chart_id, string obj_name) {
   long width = (long)ObjectGetInteger(CURR_CHART_ID, obj_name, OBJPROP_WIDTH);
   ObjectSetInteger(chart_id, obj_name, OBJPROP_WIDTH, width);
}

void CloneBack(long chart_id, string obj_name) {
   bool back = (bool)ObjectGetInteger(CURR_CHART_ID, obj_name, OBJPROP_BACK);
   ObjectSetInteger(chart_id, obj_name, OBJPROP_BACK, back);
}

void CloneSelectable(long chart_id, string obj_name) {
   bool selectable = (bool)ObjectGetInteger(CURR_CHART_ID, obj_name, OBJPROP_SELECTABLE);
   ObjectSetInteger(chart_id, obj_name, OBJPROP_SELECTABLE, selectable);
}

void CloneRay(long chart_id, string obj_name) {
   bool ray = (bool)ObjectGetInteger(CURR_CHART_ID, obj_name, OBJPROP_RAY);
   ObjectSetInteger(chart_id, obj_name, OBJPROP_RAY, ray);
}

void CloneZOrder(long chart_id, string obj_name) {
   long zorder = (long)ObjectGetInteger(CURR_CHART_ID, obj_name, OBJPROP_ZORDER);
   ObjectSetInteger(chart_id, obj_name, OBJPROP_ZORDER, zorder);
}

void CloneTimeframes(long chart_id, string obj_name) {
   ENUM_TIMEFRAMES timeframes = (ENUM_TIMEFRAMES)ObjectGetInteger(CURR_CHART_ID, obj_name, OBJPROP_TIMEFRAMES);
   ObjectSetInteger(chart_id, obj_name, OBJPROP_TIMEFRAMES, timeframes);
}

void CloneRayLeft(long chart_id, string obj_name) {
   bool ray_left = (bool)ObjectGetInteger(CURR_CHART_ID, obj_name, OBJPROP_RAY_LEFT);
   ObjectSetInteger(chart_id, obj_name, OBJPROP_RAY_LEFT, ray_left);
}

void CloneRayRight(long chart_id, string obj_name) {
   bool ray_right = (bool)ObjectGetInteger(CURR_CHART_ID, obj_name, OBJPROP_RAY_RIGHT);
   ObjectSetInteger(chart_id, obj_name, OBJPROP_RAY_RIGHT, ray_right);
}

void CloneFill(long chart_id, string obj_name) {
   bool fill = (bool)ObjectGetInteger(CURR_CHART_ID, obj_name, OBJPROP_FILL);
   ObjectSetInteger(chart_id, obj_name, OBJPROP_FILL, fill);
}

void CloneBaseObjectProps(long chart_id, string obj_name) {
   CloneColor(chart_id, obj_name);
   CloneStyle(chart_id, obj_name);
   CloneWidth(chart_id, obj_name);
   CloneBack(chart_id, obj_name);
   CloneSelectable(chart_id, obj_name);
   CloneZOrder(chart_id, obj_name);
   CloneTimeframes(chart_id, obj_name);
   SetObjectSelected(chart_id, obj_name, false);
   
   // снять выдиления с объекта, который был копирован
   SetObjectSelected(CURR_CHART_ID, obj_name, false);
}

void SetObjectSelected(long chart_id, string obj_name, bool selected) {
   ObjectSetInteger(chart_id, obj_name, OBJPROP_SELECTED, selected);
}
