#'tw50ReturnOnInvestment
#'
#'子連結:packages xts
#'
#'繼承自:multiquantmod1
#'
#'期間應該有改版 所以前版本該有所修正
#


#install.packages("quantmod")
# library(dplyr)
library(quantmod)

#disk location
Upath<-paste0("F:/")
tw50_path<-paste0(Upath,"data/new/tw50/")
tw50_dir<-dir(tw50_path)
# tw50_data_path<-paste0(tw50_path,tw50_dir[1])
# tw50_data<-read.csv(tw50_data_path)

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
  
  verbose <- FALSE
  tmp <- tempfile()
  on.exit(unlink(tmp))
  Symbols.name<-paste0(substr(tw50_dir[i],1,4),".TW")####################tw50_dir[1]  for loop
  yahoo.URL <- "http://ichart.finance.yahoo.com/table.csv?"
  stockNum_path<-paste0(yahoo.URL,Symbols.name)
  download.file(paste(yahoo.URL,
                      "s=",Symbols.name,
                      # "&a=",from.m,
                      # "&b=",sprintf('%.2d',from.d),
                      # "&c=",from.y,
                      # "&d=",to.m,
                      # "&e=",sprintf('%.2d',to.d),
                      # "&f=",to.y,
                      # "&g=d&q=q&y=0",
                      # "&z=",Symbols.name,"&x=.csv",
                      sep=''),destfile=tmp,quiet=!verbose)
  #長度超過200警告
  tw50_data <- read.csv(tmp,stringsAsFactors=FALSE)
  
  tw50_data<-mutate(tw50_data,"Open"=as.numeric(Open),"High"=as.numeric(High),"Low"=as.numeric(Low),"Close"=as.numeric(Close),"Volume"=as.numeric(Volume),"Adj"=as.numeric(Adj.Close))
  
  colnames(tw50_data)
  # [1] "Date"      "Open"      "High"      "Low"       "Close"     "Volume"    "Adj.Close" "Adj"        
  rownames(tw50_data)<-tw50_data[[1]]
  # [1] "2007-01-02" "2007-01-03" "2007-01-04" "2007-01-05" "2007-01-06" "2007-01-07" "2007-01-08" "2007-01-09" "2007-01-10" "2007-01-11" "2007-01-12"
  
  sample.xts <- as.xts(tw50_data, descr='my new xts object')
  
  is.xts(sample.xts)
  # c("date","Open","High","Low","Close","Volume")
  # sample.xts<-select(sample.xts,-1,-7)
  
  #均線資料
  ma_20<-runMean(as.numeric(sample.xts[,4]),n=20)   
  ma_60<-runMean(as.numeric(sample.xts[,4]),n=60)
  
  #符合ma_20>ma_60則1(否:0),延遲一天
  position<-Lag(ifelse(ma_20>ma_60, 1,-1))
  #(log(今天收盤價/昨天收盤價),即10^"2.2e-02"之指數)*(是否持有:1,0)
  return<-ROC(as.numeric(sample.xts$Adj.Close))*position
  #期間
  return<-return[100:2000]
  # return<-return['2012-10-27/2016-04-12']
  #(這裡運用國中數學:log(a)+log(b)=log(ab)，exp(log(ab))=ab)將持有期間之所有數字相乘
  rtw2317<-exp(cumsum(return))
  #損益圖畫出
  plot(rtw2317,main=substr(tw50_dir[i],1,4))
  result<-cbind(result,rtw2317[length(rtw2317)])
}