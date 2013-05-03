
//--- calculates position size provided the stoploss in points, and risk percentage in double
double CalculatePositionSize(int stoploss_pts, double risk_pcent)
{  
   // Find the lot size in terms of base currency
   double lot = MarketInfo(Symbol(), MODE_LOTSIZE );
   double position_size = (risk_pcent/100)*AccountBalance() / stoploss_pts; 
   double leverage = position_size*lot*Bid/AccountBalance(); 
   
   while( leverage > AccountLeverage() )
   { 
      if( leverage > AccountLeverage() )
      {
         position_size = position_size - 0.01;
         leverage = position_size*lot*Bid/AccountBalance(); 
      }
   }

   if(position_size > MarketInfo(Symbol(), MODE_MAXLOT) ) 
      position_size = MarketInfo(Symbol(), MODE_MAXLOT);
   if(position_size < MarketInfo(Symbol(), MODE_MINLOT)) 
      position_size = MarketInfo(Symbol(), MODE_MINLOT);
      
   return( position_size );
}

// Attempts to Long. Returns the ticket number
int Long(double& buy_price, datetime& traded_time, int stoploss_points, int takeprofit_points, double risk_percent, int slippage)
{
   double spread_pts = MarketInfo(Symbol(),MODE_SPREAD);
   double position_size = CalculatePositionSize(stoploss_points, risk_percent);
   int ticket = OrderSend(Symbol(), OP_BUY, position_size, Ask, slippage, 0, 0, NULL, 0, 0, Green);  
   
   if( ticket < 0 )
   {
      Print("OrderSend failed with error #" + GetLastError());
   }  
   else{
      traded_time = Time[0];
      buy_price = Ask;
      
      // Set Stoploss + Takeprofit
      double stoploss = Ask+spread_pts*Point-(stoploss_points*Point);
      double takeprofit = Ask-spread_pts*Point+(takeprofit_points*Point);
      
      Print("LOOOOOK Take Profit: "+takeprofit)
      
      if(!OrderModify(ticket, 0, stoploss, takeprofit, 0, CLR_NONE))
      {
         Print("Could not set stoploss / take profit");
         Print("Stop is: " + stoploss + "\nTake Profit is: " + takeprofit);
      }
      
      return( ticket );
   }
}

// Attempts to Short. Returns the ticket number
int Short(double& sell_price, datetime& traded_time, int stoploss_points, int takeprofit_points, double risk_percent, int slippage)
{  
   double spread_pts = MarketInfo(Symbol(),MODE_SPREAD);
   double position_size = CalculatePositionSize(stoploss_points, risk_percent);
   int ticket = OrderSend(Symbol(), OP_SELL, position_size, Bid, slippage, 0, 0, NULL, 0, 0, Red);  

   if( ticket < 0 )
   {
      Print("OrderSend failed with error #" + GetLastError());
   }
   else
   {
      traded_time = Time[0];
      sell_price = Bid;
      
      // modify stoploss + takeprofit
      double stoploss = Bid-spread_pts*Point+(stoploss_points*Point);
      double takeprofit = Bid+spread_pts*Point-(takeprofit_points*Point);
      
      if(!OrderModify(ticket, 0, stoploss, takeprofit, 0, CLR_NONE))
      {
         Print("Could not set stoploss / take profit");
         Print("Stop is: " + stoploss + "\nTake Profit is: " + takeprofit);
      }
      
      return( ticket );
   }
}

void CloseOrder(int ticket)
{
   if(OrderSelect(ticket, SELECT_BY_TICKET)==true){
      if(OrderType()==OP_BUY) 
         OrderClose(ticket,OrderLots(),Bid, 3,White);
      if(OrderType()==OP_SELL) 
         OrderClose(ticket,OrderLots(),Ask, 3,White);
   }
}

// Returns unrealized profit
double GetProfit(int ticket)
{
   if(OrderSelect(ticket, SELECT_BY_TICKET)==true){
      double unrealized_profit;
      if( OrdersTotal() > 0 )
         unrealized_profit = OrderProfit();
      else
         unrealized_profit = -1; 
   }
   return( unrealized_profit );
}

