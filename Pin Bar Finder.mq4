//+------------------------------------------------------------------+
//|                                               Pin Bar Finder.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#property indicator_buffers 6
#property indicator_color1 Red         // Bear Pinbar
#property indicator_color2 Green       // Bull Pinbar


//#property indicator_color3 Red         //inside bars -- upper wick
//#property indicator_color4 Red         //inside bars -- lower wick


extern bool pinbar_on = true;
extern bool insidebar_on = true;
extern int highlight_width = 5;
extern color insidebar_clr = Yellow;
extern double body2pin_ratio = 2.0;


string pin_name;


//--- buffers
double InsidebarUpperBuffer[];
double InsidebarLowerBuffer[];
double MotherbarUpperBuffer[];
double MotherbarLowerBuffer[];

double PinbarBearBuffer[];
double PinbarBullBuffer[];

/*
double get_max(int ind){
   int i;
   double max = Low[1];
   for(i=ind+1; i<period+ind+1; i++){
      if(High[i] > max)
         max = High[i];
   }   
   return(max);
}

double get_min(int ind){
   int i;
   double min = High[1];
   for(i=ind+1; i<period+ind+1; i++){
      if(Low[i] < min)
         min = Low[i];
   }
   return(min);
}
*/

void check_insidebar(int ind){
   bool within_neighbor_range = High[ind+1] > High[ind] && Low[ind+1] < Low[ind];
   if( within_neighbor_range ){
      MotherbarLowerBuffer[ind+1]=Low[ind+1];      
      MotherbarUpperBuffer[ind+1]=High[ind+1];     
      
      InsidebarLowerBuffer[ind]=Low[ind];
      InsidebarUpperBuffer[ind]=High[ind];      // Indicate the inside bar + Mother bar

      check_insidebar(ind+1);
   }
}

void check_pinbar(int ind){
   double pin, body;
   double neighbor1_H, neighbor1_L;
   bool body_within_neighbor_range;
   bool pin_beyond_neighbor_range;
   
   neighbor1_H = High[ind+1];
   neighbor1_L = Low[ind+1];
   body_within_neighbor_range = MathMax(Open[ind], Close[ind]) < neighbor1_H && MathMin(Open[ind], Close[ind]) > neighbor1_L;
   
// Check the bullish pinbar
   pin = MathMin(Open[ind], Close[ind])-Low[ind];
   body = High[ind]-Low[ind]-pin;
   pin_beyond_neighbor_range = Low[ind] < Low[ind+1];
   if( pin > body2pin_ratio*body && body_within_neighbor_range && pin_beyond_neighbor_range) {
      PinbarBullBuffer[ind] = Low[ind];
   }

//Check the bearish pinbar
   pin = High[ind]-MathMax(Open[ind], Close[ind]);
   body = High[ind]-Low[ind]-pin;
   pin_beyond_neighbor_range = High[ind] > High[ind+1];
   if( pin > body2pin_ratio*body && body_within_neighbor_range && pin_beyond_neighbor_range){
      // Put Bearish Pinbar!!
      PinbarBearBuffer[ind] = High[ind];
   }
   
}
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   IndicatorBuffers(6);
   
   // Bull Pinbar
   SetIndexStyle(0,DRAW_ARROW,0,2);           // Up Arrow
   SetIndexArrow(0,217);
   SetIndexBuffer(0,PinbarBullBuffer);
   SetIndexEmptyValue(0,0.0);
   
   // Bear Pinbar
   SetIndexStyle(1,DRAW_ARROW,0,2);           // Down Arrow
   SetIndexArrow(1,218);
   SetIndexBuffer(1,PinbarBearBuffer);
   SetIndexEmptyValue(1,0.0);

   SetIndexBuffer(2,InsidebarLowerBuffer);
   SetIndexStyle(2,DRAW_HISTOGRAM,0,highlight_width,insidebar_clr);
   SetIndexEmptyValue(2,0.0);

   SetIndexBuffer(3,InsidebarUpperBuffer);
   SetIndexStyle(3,DRAW_HISTOGRAM,0,highlight_width,insidebar_clr);
   SetIndexEmptyValue(3,0.0);
   
   SetIndexBuffer(4,MotherbarLowerBuffer);
   SetIndexStyle(4,DRAW_HISTOGRAM,0,highlight_width,insidebar_clr);
   SetIndexEmptyValue(4,0.0);

   SetIndexBuffer(5,MotherbarUpperBuffer);
   SetIndexStyle(5,DRAW_HISTOGRAM,0,highlight_width,insidebar_clr);
   SetIndexEmptyValue(5,0.0);
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   init();
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int i,j;
   int counted_bars=IndicatorCounted();
   int limit = Bars-counted_bars-1;
   
   for(i=0; i<limit; i++){
      if(pinbar_on) check_pinbar(i+1);
      if(insidebar_on) check_insidebar(i+1);

   }

//----
   return(0);
  }
//+----------------s--------------------------------------------------+