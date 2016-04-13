#'tw2317
#'繼承: macd quantmod1 TTR
#

library(dplyr)
library(quantmod)

#取得資料
getSymbols("2317.TW")
colnames(`2317.TW`)<-c("Open","High","Low","Close","Volume","adjusted")
tw<-as.data.frame(`2317.TW`)
DRow<-NULL
for (i in 1:nrow(tw)) {
  if (tw[i,5]==0) {
    DRow<-cbind(DRow,i)
  }
}
tw2317<-round(slice(tw,-DRow),2)

#MACD
macd  <- round(MACD( tw2317[,"Close"], 12, 26, 9, maType="EMA" ),2)
#RSI
rsi <- RSI(tw2317[,"Close"])
rsiMA1 <- RSI(tw2317[,"Close"], n=14, maType="WMA", wts=tw2317[,"Volume"])
rsiMA2 <- RSI(tw2317[,"Close"], n=14, maType=list(maUp=list(EMA,ratio=1/5),maDown=list(WMA,wts=1:10)))
# #BBands
bbands.HLC <- BBands( tw2317[,c("High","Low","Close")] )
bbands.close <- BBands( tw2317[,"Close"] )
# #stoch
stochOSC <- stoch(tw2317[,c("High","Low","Close")])
stochWPR <- WPR(tw2317[,c("High","Low","Close")])
stoch2MA <- stoch(tw2317[,c("High","Low","Close")],maType=list(list(SMA), list(EMA, wilder=TRUE), list(SMA)) )
SMI3MA <-     SMI(tw2317[,c("High","Low","Close")],maType=list(list(SMA), list(EMA, wilder=TRUE), list(SMA)) )
stochRSI <- stoch( RSI(tw2317[,"Close"]) )
#ROC　change
roc <- ROC(tw2317[,"Close"])
mom <- momentum(tw2317[,"Close"])
#ADX
dmi.adx <- ADX(tw2317[,c("High","Low","Close")])


x<-tw2317[,"Close"]
volume<-tw2317[,"Volume"]
#runSum
sum1<-runSum(x, n = 10, cumulative = FALSE)
min1<-runMin(x, n = 10, cumulative = FALSE)
max1<-runMax(x, n = 10, cumulative = FALSE)
mean1<-runMean(x, n = 10, cumulative = FALSE)
median1<-runMedian(x, n = 10, non.unique = "mean", cumulative = FALSE)
SD1<-runSD(x, n = 10, sample = TRUE, cumulative = FALSE)
MAD1<-runMAD(x, n = 10, center = NULL, stat = "median", constant = 1.4826,non.unique = "mean", cumulative = FALSE)
Wsum1<-wilderSum(x, n = 10)
var1<-runVar(x, y = NULL, n = 10, sample = TRUE, cumulative = FALSE)
#MA & VWAP
SMA1<-SMA(x, n = 10)
EMA1<-EMA(x, n = 10, wilder = FALSE, ratio = NULL)
DEMA1<-DEMA(x, n = 10, v = 1, wilder = FALSE, ratio = NULL)
WMA1<-WMA(x, n = 10, wts = 1:10)
EVWMA1<-EVWMA(x, volume, n = 10)
ZLEMA1<-ZLEMA(x, n = 10, ratio = NULL)
VWAP1<-VWAP(x, volume, n = 10)
HMA1<-HMA(x, n = 20)
ALMA1<-ALMA(x, n = 9, offset = 0.85, sigma = 6)


# cbind(tw2317,"macd","rsi","rsiMA1","rsiMA2","bbands.HLC","bbands.close","stochOSC","stochWPR","stoch2MA","SMI3MA","stochRSI","roc","mom","dmi.adx","x","volume","sum1","min1","max1","mean1","median1","SD1","MAD1","Wsum1","var1","SMA1","EMA1","DEMA1","WMA1","EVWMA1","ZLEMA1","VWAP1","HMA1","ALMA1")
a<-cbind(tw2317,macd,rsi,rsiMA1,rsiMA2,bbands.HLC,bbands.close,stochOSC,stochWPR,stoch2MA,SMI3MA,stochRSI,roc,mom,dmi.adx,x,volume,sum1,min1,max1,mean1,median1,SD1,MAD1,Wsum1,var1,SMA1,EMA1,DEMA1,WMA1,EVWMA1,ZLEMA1,VWAP1,HMA1)

# ALMA1

#disk location
Upath<-paste0("D:/")
new_path00<-paste0(Upath,"tw2317_copySetEnv.csv")
write.csv(a,file = new_path00)
