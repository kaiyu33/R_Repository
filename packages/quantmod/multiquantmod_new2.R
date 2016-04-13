#'multiquantmod_new2
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
tw50_path<-paste0(Upath,"data/new/tw50/")
tw50_dir<-dir(tw50_path)
tw50_data_path<-paste0(tw50_path,tw50_dir[1])
tw50_data<-read.csv(tw50_data_path)

result<-NULL
# i=1
for (i in 1:50) {
  # # Z<-cat(sapply(tw0050,'[[',i)[1],".TW",sep = "")
  # Z<-paste0(sapply(tw0050,'[[',i)[1],".TW",sep = "")
  # print(Z)
  # 
  # #method1
  # getSymbols("Z") 
  # Z#175
  # # #method2
  # # getSymbols("3474.TW")
  # # `3474.TW`#2355
  
  
  #均線資料
  ma_20<-runMean(tw50_data[,4],n=20)   
  ma_60<-runMean(tw50_data[,4],n=60)
  
  #符合ma_20>ma_60則1(否:0),延遲一天
  position<-Lag(ifelse(ma_20>ma_60, 1,0))
  #(log(今天收盤價/昨天收盤價),即10^"2.2e-02"之指數)*(是否持有:1,0)
  return<-ROC(tw50_data)*position
  #期間
  return<-return['2015-10-27/2016-04-12']
  #(這裡運用國中數學:log(a)+log(b)=log(ab)，exp(log(ab))=ab)將持有期間之所有數字相乘
  rtw2317<-exp(cumsum(return))
  #損益圖畫出
  plot(rtw2317)
  result<-cbind(result,rtw2317[nrow(rtw2317),])
}