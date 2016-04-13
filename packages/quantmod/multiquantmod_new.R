#'multiquantmod_new
#'
#'繼承自:multiquantmod1
#'
#'期間應該有改版 所以前版本該有所修正
#

#install.packages("quantmod")
library(dplyr)
library(quantmod)


#disk location
Upath<-paste0("D:/")
#x_path<-"file:///C:/Users/Student/Desktop/DATABASE/tw0050.csv"
x_path<-paste0("file:///",Upath,"EXdata/tw0050.csv")
readBin(x_path, "raw", n = 3L)
#可查編碼BOM
readLines(file(x_path, encoding = "BIG5"), n = 6)
#編碼錯誤會出現錯誤訊息且不顯示
# x1_path<-"C:/Users/Student/Desktop/DATABASE/tw0050.csv"
x1_path<-paste0(Upath,"EXdata/tw0050.csv")
tw0050<-read.csv(x1_path,stringsAsFactors = FALSE)
tw0050<-mutate(tw0050,NO=paste0("`",tw0050[[1]],".TW`",sep = ""))
result<-NULL
# i=1
for (i in 1:50) {
  # Z<-cat(sapply(tw0050,'[[',i)[1],".TW",sep = "")
  Z<-paste0(sapply(tw0050,'[[',i)[1],".TW",sep = "")
  print(Z)
  
  #method1
  getSymbols("Z") 
  Z#175
  # #method2
  # getSymbols("3474.TW")
  # `3474.TW`#2355
  
  
  #均線資料
  ma_20<-runMean(Z[,4],n=20)   
  ma_60<-runMean(Z[,4],n=60)
  
  #符合ma_20>ma_60則1(否:0),延遲一天
  position<-Lag(ifelse(ma_20>ma_60, 1,0))
  #(log(今天收盤價/昨天收盤價),即10^"2.2e-02"之指數)*(是否持有:1,0)
  return<-ROC(Ad(Z))*position
  #期間
  return<-return['2015-10-27/2016-04-12']
  #(這裡運用國中數學:log(a)+log(b)=log(ab)，exp(log(ab))=ab)將持有期間之所有數字相乘
  rtw2317<-exp(cumsum(return))
  #損益圖畫出
  plot(rtw2317)
  result<-cbind(result,rtw2317[nrow(rtw2317),])
}