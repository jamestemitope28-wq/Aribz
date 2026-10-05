#property strict
#property version "2.00"
#include <Trade/Trade.mqh>
CTrade trade;
input string ApiBaseUrl="https://YOUR-ARIBZ-API.example.com";
input bool DemoMode=true;
input double RiskPercent=1.0;
input int PollSeconds=5;
input int MaxSpreadPoints=80;
input bool OnePositionOnly=true;
string Get(string url){char d[],r[];string h;int c=WebRequest("GET",url,"",5000,d,0,r,h);if(c<0){Print("WebRequest error ",GetLastError());return "";}return CharArrayToString(r);}
string JStr(string j,string k){string n="\""+k+"\":";int p=StringFind(j,n);if(p<0)return "";p+=StringLen(n);while(p<StringLen(j)&&StringGetCharacter(j,p)!='\"')p++;p++;int e=p;while(e<StringLen(j)&&StringGetCharacter(j,e)!='\"')e++;return StringSubstr(j,p,e-p);}
double JNum(string j,string k){string n="\""+k+"\":";int p=StringFind(j,n);if(p<0)return 0;p+=StringLen(n);while(p<StringLen(j)&&StringGetCharacter(j,p)==' ')p++;int e=p;while(e<StringLen(j)){ushort q=StringGetCharacter(j,e);if((q>='0'&&q<='9')||q=='.'||q=='-')e++;else break;}return StringToDouble(StringSubstr(j,p,e-p));}
double Lots(double entry,double sl){double eq=AccountInfoDouble(ACCOUNT_EQUITY),tv=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE),ts=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);double loss=eq*RiskPercent/100.0;double per=(MathAbs(entry-sl)/ts)*tv;if(per<=0)return 0;double v=loss/per,min=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN),max=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX),step=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);v=MathMax(min,MathMin(max,v));if(step>0)v=MathFloor(v/step)*step;return NormalizeDouble(v,2);}
void Poll(){if(ApiBaseUrl=="https://YOUR-ARIBZ-API.example.com")return;if(OnePositionOnly&&PositionsTotal()>0)return;if(SymbolInfoInteger(_Symbol,SYMBOL_SPREAD)>MaxSpreadPoints)return;string j=Get(ApiBaseUrl+"/api/v1/execution/next");string side=JStr(j,"side");if(side!="BUY"&&side!="SELL")return;double en=JNum(j,"entry"),sl=JNum(j,"sl"),tp=JNum(j,"tp"),lot=Lots(en,sl);if(en<=0||sl<=0||tp<=0||lot<=0)return;bool ok=side=="BUY"?trade.Buy(lot,_Symbol,0,sl,tp,DemoMode?"ARIBZ DEMO":"ARIBZ"):trade.Sell(lot,_Symbol,0,sl,tp,DemoMode?"ARIBZ DEMO":"ARIBZ");if(ok)Print("ARIBZ executed ",side);}
int OnInit(){EventSetTimer(MathMax(1,PollSeconds));return INIT_SUCCEEDED;}void OnDeinit(const int r){EventKillTimer();}void OnTimer(){Poll();}
