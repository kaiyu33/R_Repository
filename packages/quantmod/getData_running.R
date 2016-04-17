#'get data
#'
#'繼承自:tw50ReturnOnInvestment2
#'
#'子連結:packages xts
#'
#'繼承自:multiquantmod1
#'
#'改以使用tw0050.csv檔案
#'增加時間點 default day 距今300天
#
Symbols.name<-paste0(2317,".TW")

verbose <- FALSE
tmp <- tempfile()
on.exit(unlink(tmp))
yahoo.URL <- "http://ichart.finance.yahoo.com/table.csv?"
# stockNum_path<-paste0(yahoo.URL,Symbols.name)

beforeDay<-300##########################取距離今天幾天前
default.from <- as.Date(as.numeric(Sys.Date())+25569-beforeDay, origin = "1899-12-30")
default.to <- Sys.Date()

from <- default.from
to <- default.to

from.y <- as.numeric(strsplit(as.character(as.Date(from,origin='1970-01-01')),'-',)[[1]][1])
from.m <- as.numeric(strsplit(as.character(as.Date(from,origin='1970-01-01')),'-',)[[1]][2])-1
from.d <- as.numeric(strsplit(as.character(as.Date(from,origin='1970-01-01')),'-',)[[1]][3])
to.y <- as.numeric(strsplit(as.character(as.Date(to,origin='1970-01-01')),'-',)[[1]][1])
to.m <- as.numeric(strsplit(as.character(as.Date(to,origin='1970-01-01')),'-',)[[1]][2])-1
to.d <- as.numeric(strsplit(as.character(as.Date(to,origin='1970-01-01')),'-',)[[1]][3])

download.file(paste(yahoo.URL,
                    "s=",Symbols.name,
                    "&a=",from.m,
                    "&b=",sprintf('%.2d',from.d),
                    "&c=",from.y,
                    "&d=",to.m,
                    "&e=",sprintf('%.2d',to.d),
                    "&f=",to.y,
                    "&g=d&q=q&y=0",
                    "&z=",Symbols.name,"&x=.csv",
                    sep=''),destfile=tmp,quiet=!verbose)
#長度超過200警告 from quantmod
tw50_data <- read.csv(tmp,stringsAsFactors=FALSE)

tw50_data<-mutate(tw50_data,"Open"=as.numeric(Open),"High"=as.numeric(High),"Low"=as.numeric(Low),"Close"=as.numeric(Close),"Volume"=as.numeric(Volume),"Adj"=as.numeric(Adj.Close))

colnames(tw50_data)
# [1] "Date"      "Open"      "High"      "Low"       "Close"     "Volume"    "Adj.Close" "Adj"
rownames(tw50_data)<-tw50_data[[1]]
# [1] "2007-01-02" "2007-01-03" "2007-01-04" "2007-01-05" "2007-01-06" "2007-01-07" "2007-01-08" "2007-01-09" "2007-01-10" "2007-01-11" "2007-01-12"

# c("date","Open","High","Low","Close","Volume")
sample.xts<-select(tw50_data,-1,-7)

sample.xts <- as.xts(sample.xts, descr='my new xts object')




# # colnames(sample.xts)
# # [1] "Open"   "High"   "Low"    "Close"  "Volume" "Adj"  
# # is.xts(sample.xts)
# 
# #均線資料
# ma_20<-runMean(as.numeric(sample.xts[,4]),n=20)
# ma_60<-runMean(as.numeric(sample.xts[,4]),n=60)
# 
# #符合ma_20>ma_60則1(否:0),延遲一天
# position<-Lag(ifelse(ma_20>ma_60, 1,-1))
# #(log(今天收盤價/昨天收盤價),即10^"2.2e-02"之指數)*(是否持有:1,0)
# return<-ROC(sample.xts$Adj)*position
# 
# for (i in 1:nrow(return)) {
#   if(is.na(return[i])){
#     j<-i
#   }else{
#     startisNumRow<-i;break
#   }
# }
# #期間
# return<-return[startisNumRow:nrow(sample.xts)]
# # return<-return['2012-10-27/2016-04-12']
# #(這裡運用國中數學:log(a)+log(b)=log(ab)，exp(log(ab))=ab)將持有期間之所有數字相乘
# rtw2317<-exp(cumsum(return))