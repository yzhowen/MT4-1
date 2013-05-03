//+------------------------------------------------------------------+
//|                                                  Custom MACD.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property  copyright "Copyright © 2004, MetaQuotes Software Corp."
#property  link      "http://www.metaquotes.net/"
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 2
#property  indicator_color1  Blue
#property  indicator_width1  2
#property  indicator_color2  Red
#property  indicator_width2  2
//---- indicator parameters
extern int period= 100;
//---- indicator buffers
double     RS_Buffer[];
double     RSEW_Buffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- drawing settings
   IndicatorBuffers(2);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   IndicatorDigits(Digits+1);
   SetIndexDrawBegin(0,period+1);
   SetIndexDrawBegin(1,period+1);
//---- indicator buffers mapping
   //SetIndexBuffer(0,RS_Buffer);
   SetIndexBuffer(1,RSEW_Buffer);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("Return Strength Indicator");
   SetIndexLabel(0,"RS");
   SetIndexLabel(1,"Weighted RS");
//---- initialization done
   
   return(0);
  }
//+------------------------------------------------------------------+
//| Moving Averages Convergence/Divergence                           |
//+------------------------------------------------------------------+
int start()
  {
   double open_close = 0;
   double PriceMove = 0;
   double TotalMove = 0;
   double PriceMoveEW = 0;
   double TotalMoveEW = 0;
   double alpha = 2.0/(period+1);
   int i, j;
   int limit;
   
   int counted_bars=IndicatorCounted();
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   i=limit;
   while(i>=0){
      PriceMove = 0;
      PriceMoveEW = 0;
      TotalMove = 0;
      TotalMoveEW = 0;
      
      if(i+period <= Bars){
         for(j=i+period; j>=i; j--){
            open_close = (iClose(Symbol(),NULL,j)-iOpen(Symbol(),NULL,j));
            PriceMove = PriceMove + open_close;
            PriceMoveEW = alpha*open_close + (1-alpha)*PriceMoveEW;
            TotalMove = TotalMove + MathAbs(open_close);
            TotalMoveEW = alpha*MathAbs(open_close) + (1-alpha)*TotalMoveEW;
            
         }
         // Update the Return Strength Value
         RS_Buffer[i] = 100*PriceMove/TotalMove;
         RSEW_Buffer[i] = 100*PriceMoveEW/TotalMoveEW;
      }
      i--;
   }
      
//---- done
   return(0);
  }
//+------------------------------------------------------------------+