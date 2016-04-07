#台股######################################################################################

library(dplyr)
#install.packages("quantmod")
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

tw2317<-slice(tw,-DRow)
# as.xts(tw2317)
# slice(tw,1:10)
# slice()
macd  <- MACD( tw2317[,"Close"], 12, 26, 9, maType="EMA" )
macd2  <- MACD( tw2317[,"Close"], 12, 26, 9, maType="EMA" ,percent=TRUE)
macd3 <- MACD(  tw2317[,"Close"],12, 26, 9, maType=list(list(SMA), list(EMA, wilder=TRUE), list(SMA)) )

EMA(tw2317[,"Close"], 12,wilder = TRUE)

EMA(tw2317[,"Close"], 12)
A<-EMA(`2317.TW`[,"Close"], 12)-EMA(`2317.TW`[,"Close"], 26)
A-EMA(A[,"EMA"], 9)

# # 縮寫 最長四個字
# abbreviate(names( `2317.TW`),minlength = 4)
# # Open     High      Low    Close   Volume adjusted 
# # "Open"   "High"    "Low"   "Clos"   "Volm"   "adjs" 
macd  <- MACD( `2317.TW`[,"Close"], 12, 26, 9, maType="EMA",percent=TRUE )

macd  <- MACD( `2317.TW`[,"adjusted"], 12, 26, 9, maType="EMA",percent=TRUE )
macd2 <- MACD(  `2317.TW`[,"adjusted"],12, 26, 9, maType=list(list(SMA), list(EMA, wilder=TRUE), list(SMA)) )


# > names(macd)
# [1] "macd"   "signal"

yahoo
MACD DIF EMA12 EMA26

# 一、差離值（DIF值）：[2][3]
# 先利用收盤價的指數移動平均值（12日／26日）計算出差離值。[4]
# 〖公式〗
# DIF = EMA_{(close,12)} - EMA_{(close,26)}
#DIF=MA12-MA26
# 二、訊號線（DEM值，又稱MACD值）：
# 計算出DIF後，會再畫一條「訊號線」，通常是DIF的9日指數移動平均值。
# 〖公式〗
# DEM = EMA_{(DIF,9)}
# 三、柱形圖或棒形圖（histogram / bar graph）：
# 接著，將DIF與DEM的差畫成「柱形圖」（MACD bar / OSC）。
# 〖公式〗
# OSC = DIF - DEM
# 簡寫為
# D - M

#均線資料
ma_20<-runMean(`2317.TW`[,4],n=20)   
ma_60<-runMean(`2317.TW`[,4],n=60)
#加入均線
addTA(ma_20,on=1,col="blue")
addTA(ma_60,on=1,col="red")
addBBands()
#Bollinger%b = (Close-LowerBound) / (UpperBound-LowerBound)
addBBands(draw="p")
addMACD()
#進行策略回測

#符合ma_20>ma_60則1(否:0),延遲一天
position<-Lag(ifelse(ma_20>ma_60, 1,0))
#(log(今天收盤價/昨天收盤價),即10^"2.2e-02"之指數)*(是否持有:1,0)
return<-ROC(Ad(`2317.TW`))*position
#期間
return<-return['2007-04-10/2013-12-31']
#(這裡運用國中數學:log(a)+log(b)=log(ab)，exp(log(ab))=ab)將持有期間之所有數字相乘
return<-exp(cumsum(return))
#損益圖畫出
plot(return)