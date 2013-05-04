//+------------------------------------------------------------------+
//|                                           CorrelationMonitor.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_separate_window
//--- input parameters
extern int       period=100;
extern bool      eurusd=true;
extern bool      usdjpy=true;
extern bool      gbpusd=true;
extern bool      usdchf=true;
extern bool      usdcad=true;
extern bool      audusd=true;
extern bool      nzdusd=true;
extern bool      xauusd=true;
extern bool      xagusd=true;
extern bool      eurjpy=true;
extern bool      gbpjpy=true;
extern bool      audjpy=true;
extern bool      nzdjpy=true;

extern color font_color = Red;
extern int font_size = 10;
extern string font_face = "Courier";
extern int corner = 0; //0 - for top-left corner, 1 - top-right, 2 - bottom-left, 3 - bottom-right
extern int distance_x = 10;
extern int distance_y = 15;


void get_correlation(string symbol){
   int i;
   double corr, diffxy, diffxx, diffyy, mu_x, mu_y;
   double retsum_x, retsum_y;
   double ret_x[], ret_y[];
   
   ArrayResize(ret_x, period);
   ArrayResize(ret_y, period);

   // Calculate past returns
   for(i=0; i<period; i++){
      ret_x[i] = (iClose(Symbol(),NULL,i)-iOpen(Symbol(),NULL,i))/iOpen(Symbol(),NULL,i);
      ret_y[i] = (iClose(symbol,NULL,i)-iOpen(symbol,NULL,i))/iOpen(symbol,NULL,i);
      
      retsum_x += ret_x[i];
      retsum_y += ret_y[i];
   }
   
   // Calculate return average
   mu_x = retsum_x/period;
   mu_y = retsum_y/period;
   
   // Calculate Correlation!!
   // rho = Cov(X,Y)/Sqrt(Var(X)*Var(Y))
   for(i=0; i<period; i++){
      diffxy += (ret_x[i]-mu_x)*(ret_y[i]-mu_y);
      diffxx += MathPow(ret_x[i]-mu_x,2);
      diffyy += MathPow(ret_y[i]-mu_y,2); 
   }
   corr = diffxy/MathSqrt(diffxx*diffyy);
   ObjectSetText(symbol, symbol+": "+DoubleToStr(corr, 2), font_size, font_face, font_color);
}

int init()
  {
//---- indicators
   
   ObjectCreate("EURUSD", OBJ_LABEL, WindowFind("CorrelationMonitor"), 0, 0);
   ObjectSet("EURUSD", OBJPROP_CORNER, corner);
   ObjectSet("EURUSD", OBJPROP_XDISTANCE, distance_x);
   ObjectSet("EURUSD", OBJPROP_YDISTANCE, distance_y);
   
   ObjectCreate("USDJPY", OBJ_LABEL, WindowFind("CorrelationMonitor"), 0, 0);
   ObjectSet("USDJPY", OBJPROP_CORNER, corner);
   ObjectSet("USDJPY", OBJPROP_XDISTANCE, distance_x);
   ObjectSet("USDJPY", OBJPROP_YDISTANCE, 2*distance_y);
   
   ObjectCreate("GBPUSD", OBJ_LABEL, WindowFind("CorrelationMonitor"), 0, 0);
   ObjectSet("GBPUSD", OBJPROP_CORNER, corner);
   ObjectSet("GBPUSD", OBJPROP_XDISTANCE, distance_x);
   ObjectSet("GBPUSD", OBJPROP_YDISTANCE, 3*distance_y);
   
   ObjectCreate("USDCHF", OBJ_LABEL, WindowFind("CorrelationMonitor"), 0, 0);
   ObjectSet("USDCHF", OBJPROP_CORNER, corner);
   ObjectSet("USDCHF", OBJPROP_XDISTANCE, distance_x);
   ObjectSet("USDCHF", OBJPROP_YDISTANCE, 4*distance_y);
   
   ObjectCreate("USDCAD", OBJ_LABEL, WindowFind("CorrelationMonitor"), 0, 0);
   ObjectSet("USDCAD", OBJPROP_CORNER, corner);
   ObjectSet("USDCAD", OBJPROP_XDISTANCE, distance_x);
   ObjectSet("USDCAD", OBJPROP_YDISTANCE, 5*distance_y);

   ObjectCreate("AUDUSD", OBJ_LABEL, WindowFind("CorrelationMonitor"), 0, 0);
   ObjectSet("AUDUSD", OBJPROP_CORNER, corner);
   ObjectSet("AUDUSD", OBJPROP_XDISTANCE, distance_x);
   ObjectSet("AUDUSD", OBJPROP_YDISTANCE, 6*distance_y);
   
   ObjectCreate("NZDUSD", OBJ_LABEL, WindowFind("CorrelationMonitor"), 0, 0);
   ObjectSet("NZDUSD", OBJPROP_CORNER, corner);
   ObjectSet("NZDUSD", OBJPROP_XDISTANCE, 20*distance_x);
   ObjectSet("NZDUSD", OBJPROP_YDISTANCE, distance_y);
   
   ObjectCreate("XAUUSD", OBJ_LABEL, WindowFind("CorrelationMonitor"), 0, 0);
   ObjectSet("XAUUSD", OBJPROP_CORNER, corner);
   ObjectSet("XAUUSD", OBJPROP_XDISTANCE, 20*distance_x);
   ObjectSet("XAUUSD", OBJPROP_YDISTANCE, 2*distance_y);
   
   ObjectCreate("XAGUSD", OBJ_LABEL, WindowFind("CorrelationMonitor"), 0, 0);
   ObjectSet("XAGUSD", OBJPROP_CORNER, corner);
   ObjectSet("XAGUSD", OBJPROP_XDISTANCE, 20*distance_x);
   ObjectSet("XAGUSD", OBJPROP_YDISTANCE, 3*distance_y);

   ObjectCreate("EURJPY", OBJ_LABEL, WindowFind("CorrelationMonitor"), 0, 0);
   ObjectSet("EURJPY", OBJPROP_CORNER, corner);
   ObjectSet("EURJPY", OBJPROP_XDISTANCE, 20*distance_x);
   ObjectSet("EURJPY", OBJPROP_YDISTANCE, 4*distance_y);
  
   ObjectCreate("GBPJPY", OBJ_LABEL, WindowFind("CorrelationMonitor"), 0, 0);
   ObjectSet("GBPJPY", OBJPROP_CORNER, corner);
   ObjectSet("GBPJPY", OBJPROP_XDISTANCE, 20*distance_x);
   ObjectSet("GBPJPY", OBJPROP_YDISTANCE, 5*distance_y); 

   ObjectCreate("AUDJPY", OBJ_LABEL, WindowFind("CorrelationMonitor"), 0, 0);
   ObjectSet("AUDJPY", OBJPROP_CORNER, corner);
   ObjectSet("AUDJPY", OBJPROP_XDISTANCE, 20*distance_x);
   ObjectSet("AUDJPY", OBJPROP_YDISTANCE, 6*distance_y); 
   
   ObjectCreate("NZDJPY", OBJ_LABEL, WindowFind("CorrelationMonitor"), 0, 0);
   ObjectSet("NZDJPY", OBJPROP_CORNER, corner);
   ObjectSet("NZDJPY", OBJPROP_XDISTANCE, 20*distance_x);
   ObjectSet("NZDJPY", OBJPROP_YDISTANCE, 7*distance_y); 
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectDelete("EURUSD");
   ObjectDelete("USDJPY");
   ObjectDelete("GBPUSD");
   ObjectDelete("USDCHF");
   ObjectDelete("USDCAD");
   ObjectDelete("AUDUSD");
   ObjectDelete("NZDUSD");
   ObjectDelete("XAUUSD");
   ObjectDelete("XAGUSD");
   ObjectDelete("EURJPY");
   ObjectDelete("GBPJPY");
   ObjectDelete("AUDJPY");
   ObjectDelete("NZDJPY");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
  
   if(eurusd) get_correlation("EURUSD");
   if(usdjpy) get_correlation("USDJPY");
   if(gbpusd) get_correlation("GBPUSD");
   if(usdchf) get_correlation("USDCHF");
   if(usdcad) get_correlation("USDCAD");
   if(audusd) get_correlation("AUDUSD");
   if(nzdusd) get_correlation("NZDUSD");
   if(xauusd) get_correlation("XAUUSD");
   if(xagusd) get_correlation("XAGUSD");
   if(eurjpy) get_correlation("EURJPY");
   if(gbpjpy) get_correlation("GBPJPY");
   if(audjpy) get_correlation("AUDJPY");
   if(nzdjpy) get_correlation("NZDJPY");
   
   return(0);
  }
//+------------------------------------------------------------------+