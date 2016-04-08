#'packages TTR
#
#install.packages("quantmod")
library(quantmod)


#WebData

a<-stockSymbols("NYSE")
# head(a)
# Symbol                       Name LastSale MarketCap IPOyear            Sector                                         Industry Exchange
# 1      A Agilent Technologies, Inc.    39.47   $12.94B    1999     Capital Goods Biotechnology: Laboratory Analytical Instruments     NYSE
# 2     AA                 Alcoa Inc.     9.48   $12.46B      NA     Capital Goods                               Metal Fabrications     NYSE
# 3  AA-PB                 Alcoa Inc.    32.65      <NA>      NA              <NA>                                             <NA>     NYSE
# 4    AAC         AAC Holdings, Inc.    19.02  $437.18M    2014       Health Care                             Medical Specialities     NYSE
# 5    AAN         Aaron&#39;s,  Inc.    25.82    $1.87B      NA        Technology                  Diversified Commercial Services     NYSE
# 6    AAP     Advance Auto Parts Inc   155.83   $11.43B      NA Consumer Services                           Other Specialty Stores     NYSE

#default 還原除權息
ibm <- getYahooData("IBM", 19990404, 20050607)
# Open     High      Low    Close   Volume Unadj.Close Div Split Adj.Div
# 1999-04-05 69.89128 71.81914 69.72045 71.81914 11830329    183.9375  NA    NA      NA
# 1999-04-06 71.50190 72.91729 71.13585 71.45309 11195683    183.0000  NA    NA      NA
# 1999-04-07 71.84355 73.25894 69.91568 72.81968 14933895    186.5000  NA    NA      NA
# 1999-04-08 72.62445 73.42977 71.18466 73.01491 10924461    187.0000  NA    NA      NA
# 1999-04-09 72.47803 73.42977 71.84355 72.74647  7826529    186.3125  NA    NA      NA
# 1999-04-12 71.64832 71.69713 70.69659 71.62392 11499176    183.4375  NA    NA      NA
tw2317<-getYahooData("2317.TW", 20010404, 20050607)
# Open     High      Low    Close   Volume Unadj.Close Div Split Adj.Div
# 2001-04-04 56.76305 57.34233 56.47347 56.76305 31197851    116.6486  NA    NA      NA
# 2001-04-06 57.34233 58.21120 56.76305 57.34233 34190737    117.8390  NA    NA      NA
# 2001-04-09 56.76305 57.05276 56.47347 56.76305 15406530    116.6486  NA    NA      NA
# 2001-04-10 57.63191 58.21120 56.18389 56.18389 31449270    115.4584  NA    NA      NA
# 2001-04-11 56.76305 57.05276 55.02545 56.18389 37807594    115.4584  NA    NA      NA
# 2001-04-12 56.76305 57.63191 56.47347 57.34233 20756092    117.8390  NA    NA      NA
head(getYahooData("2317.TW"))
# Open     High      Low    Close   Volume Unadj.Close Div Split Adj.Div
# 1993-01-05 1.277550 1.301704 1.269493 1.277550 29313585     3.62302  NA    NA      NA
# 1993-01-06 1.274860 1.274860 1.245342 1.256072 41018270     3.56211  NA    NA      NA
# 1993-01-07 1.256072 1.274860 1.245342 1.250705 38917587     3.54689  NA    NA      NA
# 1993-01-08 1.266806 1.266806 1.202400 1.213130 38262733     3.44033  NA    NA      NA
# 1993-01-11 1.210453 1.239975 1.210453 1.221187 12318475     3.46318  NA    NA      NA
# 1993-01-12 1.215820 1.250705 1.215820 1.250705 17679362     3.54689  NA    NA      NA

getSymbols("2317.TW")#20070102- BY quantmod   default: 不還原除權息,原始股價

#MA & VWAP
SMA(x, n = 10, ...)
EMA(x, n = 10, wilder = FALSE, ratio = NULL, ...)
DEMA(x, n = 10, v = 1, wilder = FALSE, ratio = NULL)
WMA(x, n = 10, wts = 1:n, ...)
EVWMA(price, volume, n = 10, ...)
ZLEMA(x, n = 10, ratio = NULL, ...)
VWAP(price, volume, n = 10, ...)
VMA(x, w, ratio = 1, ...)
HMA(x, n = 20, ...)
ALMA(x, n = 9, offset = 0.85, sigma = 6, ...)

#MACD
macd  <- MACD( ttrc[,"Close"], 12, 26, 9, maType="EMA" )
macd2 <- MACD( ttrc[,"Close"], 12, 26, 9,
               maType=list(list(SMA), list(EMA, wilder=TRUE), list(SMA)) )

#stoch
stoch(HLC, nFastK = 14, nFastD = 3, nSlowD = 3, maType, bounded = TRUE,smooth = 1, ...)
SMI(HLC, n = 13, nFast = 2, nSlow = 25, nSig = 9, maType,bounded = TRUE, ...)
##Examples
data(ttrc)
stochOSC <- stoch(ttrc[,c("High","Low","Close")])
stochWPR <- WPR(ttrc[,c("High","Low","Close")])

plot(tail(stochOSC[,"fastK"], 100), type="l",main="Fast %K and Williams %R", ylab="",ylim=range(cbind(stochOSC, stochWPR), na.rm=TRUE) )
lines(tail(stochWPR, 100), col="blue")
lines(tail(1-stochWPR, 100), col="red", lty="dashed")

stoch2MA <- stoch( ttrc[,c("High","Low","Close")],maType=list(list(SMA), list(EMA, wilder=TRUE), list(SMA)) )
SMI3MA <- SMI(ttrc[,c("High","Low","Close")],maType=list(list(SMA), list(EMA, wilder=TRUE), list(SMA)) )
stochRSI <- stoch( RSI(ttrc[,"Close"]) )


#RSI
RSI(price, n = 14, maType, ...)
##Examples
data(ttrc)
price <- ttrc[,"Close"]
# Default case
rsi <- RSI(price)
# Case of one 'maType' for both MAs
rsiMA1 <- RSI(price, n=14, maType="WMA", wts=ttrc[,"Volume"])
# Case of two different 'maType's for both MAs
rsiMA2 <- RSI(price, n=14, maType=list(maUp=list(EMA,ratio=1/5), maDown=list(WMA,wts=1:10)))

#BBands
BBands(HLC, n = 20, maType, sd = 2, ...)
data(ttrc)
bbands.HLC <- BBands( ttrc[,c("High","Low","Close")] )
bbands.close <- BBands( ttrc[,"Close"] )

#ROC　change
ROC(x, n = 1, type = c("continuous", "discrete"), na.pad = TRUE)

momentum(x, n = 1, na.pad = TRUE)

data(ttrc)
roc <- ROC(ttrc[,"Close"])
mom <- momentum(ttrc[,"Close"])



#ADX
ADX(HLC, n = 14, maType, ...)
data(ttrc)
dmi.adx <- ADX(ttrc[,c("High","Low","Close")])

#runSum
runSum(x, n = 10, cumulative = FALSE)

runMin(x, n = 10, cumulative = FALSE)

runMax(x, n = 10, cumulative = FALSE)

runMean(x, n = 10, cumulative = FALSE)

runMedian(x, n = 10, non.unique = "mean", cumulative = FALSE)

runCov(x, y, n = 10, use = "all.obs", sample = TRUE, cumulative = FALSE)

runCor(x, y, n = 10, use = "all.obs", sample = TRUE, cumulative = FALSE)

runVar(x, y = NULL, n = 10, sample = TRUE, cumulative = FALSE)

runSD(x, n = 10, sample = TRUE, cumulative = FALSE)

runMAD(x, n = 10, center = NULL, stat = "median", constant = 1.4826,
       non.unique = "mean", cumulative = FALSE)

wilderSum(x, n = 10)