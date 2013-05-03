//+------------------------------------------------------------------+
//|                                                 PositionSize.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_separate_window

//--- input parameters
extern bool      use_money_instead_of_percet=false;    
extern double    risk_pct=0.02;
extern double    risk_money=100.0;
extern double    stop_level;

extern color ps_font_color = Red;
extern int font_size = 12;
extern string font_face = "Courier";
extern int corner = 0; //0 - for top-left corner, 1 - top-right, 2 - bottom-left, 3 - bottom-right
extern int distance_x = 10;
extern int distance_y = 15;


int position;
#define LONG   1
#define SHORT  2

double position_size;
double entry_level;


void calculate_position(){
   if( position == LONG ) entry_level = Ask;
   if( position == SHORT ) entry_level = Bid;
   
   double dist2stop = MathAbs(stop_level - entry_level);
   double size = AccountBalance();
   double unit_cost = MarketInfo(Symbol(), MODE_TICKVALUE);
   double tick_size = MarketInfo(Symbol(), MODE_TICKSIZE);
      
   if (!use_money_instead_of_percet) 
      risk_money = size *risk_pct;

   position_size = risk_money / (dist2stop * unit_cost / tick_size);
   
   ObjectSetText("PositionSize", "Pos. Size:        " + DoubleToStr(position_size, 2), font_size + 1, font_face, ps_font_color);
   ObjectSetText("Stop",         "Stop Level:       " + DoubleToStr(stop_level, 4), font_size, font_face, ps_font_color);
   ObjectSetText("Risk",         "Money At Risk:   $" + DoubleToStr(risk_money, 2), font_size, font_face, ps_font_color);
}

int init()
  {
//---- indicators
   ObjectDelete("Risk");
   ObjectDelete("PositionSize");
   ObjectDelete("Stop");
   
   ObjectCreate("PositionSize", OBJ_LABEL, 1, 0, 0);
   ObjectSet("PositionSize", OBJPROP_CORNER, corner);
   ObjectSet("PositionSize", OBJPROP_XDISTANCE, distance_x);
   ObjectSet("PositionSize", OBJPROP_YDISTANCE, distance_y+30);
   
   ObjectCreate("Stop", OBJ_LABEL, 1, 0, 0);
   ObjectSet("Stop", OBJPROP_CORNER, corner);
   ObjectSet("Stop", OBJPROP_XDISTANCE, distance_x);
   ObjectSet("Stop", OBJPROP_YDISTANCE, distance_y+15);
   
   ObjectCreate("Risk", OBJ_LABEL, 1, 0, 0);
   ObjectSet("Risk", OBJPROP_CORNER, corner);
   ObjectSet("Risk", OBJPROP_XDISTANCE, distance_x);
   ObjectSet("Risk", OBJPROP_YDISTANCE, distance_y);

   
   if( stop_level > Ask ) {
      position = SHORT;
      entry_level = Bid;
   }
   
   if( stop_level < Bid ){
      position = LONG;
      entry_level = Ask;
   }
   
//----
   return(0);
  }
  
int deinit()
  {
//----
   ObjectDelete("Risk");
   ObjectDelete("PositionSize");
   ObjectDelete("Stop");
   
//----
   return(0);
  }
  
int start()
  {
   calculate_position();
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+


