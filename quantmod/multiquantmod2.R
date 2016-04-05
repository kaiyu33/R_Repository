#TW50

#install.packages("quantmod")
library(quantmod)

#x_path<-"file:///C:/Users/Student/Desktop/DATABASE/tw0050.csv"
x_path<-"file:///F:/EXdata/tw0050.csv"
readBin(x_path, "raw", n = 3L)
#可查編碼BOM
readLines(file(x_path, encoding = "BIG5"), n = 6)
#編碼錯誤會出現錯誤訊息且不顯示
# x1_path<-"C:/Users/Student/Desktop/DATABASE/tw0050.csv"
x1_path<-"F:/EXdata/tw0050.csv"
tw0050<-read.csv(x1_path,stringsAsFactors = FALSE)
tw0050<-mutate(tw0050,NO=paste0("`",tw0050[[1]],".TW`",sep = ""))

A<-for (i in 1:50) {
  Y<-  function(x){
    Z<-paste("`",sapply(tw0050,'[[',i)[1],".TW`",sep = "")
    getSymbols("Z") }
}

for (i in 1:50) {
  n<- paste("tw50",i,sep=".")
  assign(n,paste(sapply(tw0050,'[[',i)[1],".TW",sep = ""))
}

tw50.2
getSymbols(tw50.2)
b<-print("`",tw50.2,"`",sep = "")
chartSeries(b)
chartSeries(`4938.TW`)

#台股######################################################################################
getSymbols("2317.TW")
chartSeries(`2317.TW`)
#chartSeries(`2317.TW`["2000-01::2012-06"],theme="white")

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