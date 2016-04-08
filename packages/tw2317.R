#'tw2317
#'繼承: macd quantmod1 TTR
#

library(dplyr)
library(quantmod)

#取得資料
getSymbols("2317.TW")

# #顯示圖表
# chartSeries(`2317.TW`)
# #chartSeries(`2317.TW`["2000-01::2012-06"],theme="white")

#與colnames相同
colnames(`2317.TW`)<-c("Open","High","Low","Close","Volume","adjusted")
#names( `2317.TW`)

tw<-as.data.frame(`2317.TW`)
# class(tw[1,1])
# tw[,5]!=0
# slice(tw,tw[,5]!=0)
# nrow(tw)
# [1] 2339

DRow<-NULL
for (i in 1:nrow(tw)) {
  if (tw[i,5]==0) {
    DRow<-cbind(DRow,i)
  }
}

tw2317<-round(slice(tw,-DRow),2)
# as.xts(tw2317)
# slice(tw,1:10)
# slice()


#MACD
macd  <- round(MACD( tw2317[,"Close"], 12, 26, 9, maType="EMA" ),2)
colnames(macd)



#RSI
# Default case
rsi <- RSI(tw2317[,"Close"])
# Case of one 'maType' for both MAs
rsiMA1 <- RSI(tw2317[,"Close"], n=14, maType="WMA", wts=tw2317[,"Volume"])
# Case of two different 'maType's for both MAs
rsiMA2 <- RSI(tw2317[,"Close"], n=14, maType=list(maUp=list(EMA,ratio=1/5),maDown=list(WMA,wts=1:10)))
# > tail(rsi)
# [1] 58.07245 62.19646 53.00831 45.73263 47.03740 48.80484
# > tail(rsiMA1)
# [1] 62.95380 71.51620 61.57489 50.39191 58.34888 57.25636
# > tail(rsiMA2)
# [1] 50.76935 64.68950 40.76689 27.02865 29.73912 34.47863



# #BBands
# BBands(HLC, n = 20, maType, sd = 2, ...)
bbands.HLC <- BBands( tw2317[,c("High","Low","Close")] )
bbands.close <- BBands( tw2317[,"Close"] )
# > tail(BBands( tw2317[,"Close"] ))
# dn   mavg       up        pctB
# [2254,] 80.47703 83.090 85.70297  0.61672552
# [2255,] 81.22101 83.355 85.48899  0.83856815
# [2256,] 81.78106 83.480 85.17894  0.35873552
# [2257,] 81.43799 83.395 85.35201 -0.06080362
# [2258,] 81.41425 83.390 85.36575  0.02170135
# [2259,] 81.26013 83.335 85.40987  0.15419578
# > tail(BBands( tw2317[,c("High","Low","Close")] ))
# dn     mavg       up        pctB
# [2254,] 80.32834 83.03500 85.74166  0.67210656
# [2255,] 81.16504 83.34167 85.51830  0.92688296
# [2256,] 81.89272 83.51000 85.12728  0.50721375
# [2257,] 81.83055 83.49667 85.16279  0.01083953
# [2258,] 81.57178 83.44333 85.31489 -0.09041872
# [2259,] 81.41114 83.40333 85.39553  0.03903462



# #stoch
# stoch(HLC, nFastK = 14, nFastD = 3, nSlowD = 3, maType, bounded = TRUE,smooth = 1, ...)
# SMI(HLC, n = 13, nFast = 2, nSlow = 25, nSig = 9, maType,bounded = TRUE, ...)
##Examples
data(ttrc)
stochOSC <- stoch(tw2317[,c("High","Low","Close")])
stochWPR <- WPR(tw2317[,c("High","Low","Close")])

plot(tail(stochOSC[,"fastK"], 100), type="l",main="Fast %K and Williams %R", ylab="",ylim=range(cbind(stochOSC, stochWPR), na.rm=TRUE) )
lines(tail(stochWPR, 100), col="blue")
lines(tail(1-stochWPR, 100), col="red", lty="dashed")

stoch2MA <- stoch(tw2317[,c("High","Low","Close")],maType=list(list(SMA), list(EMA, wilder=TRUE), list(SMA)) )
SMI3MA <-     SMI(tw2317[,c("High","Low","Close")],maType=list(list(SMA), list(EMA, wilder=TRUE), list(SMA)) )
stochRSI <- stoch( RSI(tw2317[,"Close"]) )

# > tail(stochOSC)
# fastK     fastD     slowD
# [2254,] 0.5666667 0.7035088 0.7840917
# [2255,] 0.5833333 0.6611111 0.7258285
# [2256,] 0.2083333 0.4527778 0.6057992
# [2257,] 0.0000000 0.2638889 0.4592593
# [2258,] 0.1846154 0.1309829 0.2825499
# [2259,] 0.2461538 0.1435897 0.1794872
# > tail(stochWPR)
# [1] 0.4333333 0.4166667 0.7916667 1.0000000 0.8153846 0.7538462
###  stochOSC$fastK + stochWPR =1

# > tail(stoch2MA)
# fastK     fastD     slowD
# [2254,] 0.5666667 0.7035088 0.8106502
# [2255,] 0.5833333 0.6611111 0.7608038
# [2256,] 0.2083333 0.4527778 0.6581285
# [2257,] 0.0000000 0.2638889 0.5267153
# [2258,] 0.1846154 0.1309829 0.3948045
# [2259,] 0.2461538 0.1435897 0.3110662
# > tail(SMI3MA)
# SMI   signal
# [2254,] 36.31889 33.49302
# [2255,] 35.75736 34.37864
# [2256,] 33.87596 34.85724
# [2257,] 29.73037 34.63050
# [2258,] 25.11651 33.70318
# [2259,] 21.43477 32.23919
# > tail(stochRSI)
# fastK      fastD      slowD
# [2254,] 7.536026e-16 0.19596772 0.34108964
# [2255,] 4.373924e-01 0.29351184 0.29756966
# [2256,] 4.902743e-16 0.14579748 0.21175901
# [2257,] 3.718859e-16 0.14579748 0.19503560
# [2258,] 6.828913e-02 0.02276304 0.10478600
# [2259,] 1.607941e-01 0.07636108 0.08164053


##############################################################################
tw2317m<-cbind(tw2317,macd)#XXXXXXX




#ROC　change
#runSum
#ADX
#MA & VWAP


