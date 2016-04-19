#'tw50ReturnOnInvestment
#'
#'子連結:packages xts
#'
#'繼承自:multiquantmod1
#'
#'改版:2
#'改以使用tw0050.csv檔案
#'增加時間點 default day 距今300天
#'
#'改版:3
#'增加APP get data write
#'改以以日期做為選擇時間點 而非距今幾日
#'轉xts 用xts的方法 更快速簡潔
#'欄位調整 VOL=0刪除
#'建立周報酬報表
#'
#'跳過改版4
#'
#'改版:5
#'

#install.packages("quantmod")
# library(dplyr)
library(quantmod)



#disk location
Upath<-paste0("D:/")

# #meyhod:1 read dir
# tw50_path<-paste0(Upath,"data/new/tw50/")
# tw50_dir<-dir(tw50_path)
# # tw50_data_path<-paste0(tw50_path,tw50_dir[1])
# # tw50_data<-read.csv(tw50_data_path)

#meyhod:2 read table file of csv
tw50_path<-paste0(Upath,"EXdata/tw0050.csv")
tw50_dir<-read.csv(tw50_path,stringsAsFactors = FALSE)
tw50_dir<-tw50_dir[[1]]

#setting zone 1
from <- "2010-01-01"
to <- "2016-04-17"
stockNum<-tw50_dir

for (i in 1:length(stockNum)) {
  Symbols.name<-paste0(substr(stockNum[i],1,4),".TW")####################tw50_dir[1]  for loop
  
  #meyhod:3 make function on app
  #datasetInput <- reactive({#########################################################################################################app start
  # Symbols.name<-paste0(input$ID,".TW")####################app use
  
  
  verbose <- FALSE###############################################################################################
  tmp <- tempfile()
  on.exit(unlink(tmp))
  
  beforeDay<-300##########################取距離今天幾天前
  default.from <- as.Date(as.numeric(Sys.Date())+25569-beforeDay, origin = "1899-12-30")
  default.to <- Sys.Date()
  
  from <- if(is.null(from)) default.from else from
  to <- if(is.null(to)) default.to else to
  
  from.y <- as.numeric(strsplit(as.character(as.Date(from,origin='1970-01-01')),'-',)[[1]][1])
  from.m <- as.numeric(strsplit(as.character(as.Date(from,origin='1970-01-01')),'-',)[[1]][2])-1
  from.d <- as.numeric(strsplit(as.character(as.Date(from,origin='1970-01-01')),'-',)[[1]][3])
  to.y <- as.numeric(strsplit(as.character(as.Date(to,origin='1970-01-01')),'-',)[[1]][1])
  to.m <- as.numeric(strsplit(as.character(as.Date(to,origin='1970-01-01')),'-',)[[1]][2])-1
  to.d <- as.numeric(strsplit(as.character(as.Date(to,origin='1970-01-01')),'-',)[[1]][3])
  
  yahoo.URL <- "http://ichart.finance.yahoo.com/table.csv?"
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
  
  tw50_data<-filter(tw50_data,  Volume > 0)#去除VOL=0
  # tw50_data<-arrange(tw50_data,desc(Date))#一時間排列  進入xts一樣沒用
  
  sample.xts<-xts(as.matrix(tw50_data[,-1]),
                  as.Date(tw50_data[,1]),
                  #as.POSIXct(fr[,1], tz=Sys.getenv("TZ")),
                  src='yahoo',updated=Sys.time())
  
  time(sample.xts[1])
  # [1] "2015-06-22"
  
  attr(sample.xts, "dimnames") #等同於 dimnames(sample.xts)
  # [[1]]
  # NULL
  # 
  # [[2]]
  # [1] "Open"      "High"      "Low"       "Close"     "Volume"    "Adj.Close"
  
  attr(sample.xts, "dimnames")[[2]][6]<-"Adj"
  attr(sample.xts, "dimnames")[[2]][6]
  # [1] "Adj"
  
  # tw50_data<-mutate(tw50_data,"Open"=as.numeric(Open),"High"=as.numeric(High),"Low"=as.numeric(Low),"Close"=as.numeric(Close),"Volume"=as.numeric(Volume),"Adj"=as.numeric(Adj.Close))
  # 
  # colnames(tw50_data)
  # # [1] "Date"      "Open"      "High"      "Low"       "Close"     "Volume"    "Adj.Close" "Adj"
  # rownames(tw50_data)<-tw50_data[[1]]
  # # [1] "2007-01-02" "2007-01-03" "2007-01-04" "2007-01-05" "2007-01-06" "2007-01-07" "2007-01-08" "2007-01-09" "2007-01-10" "2007-01-11" "2007-01-12"
  # 
  # # c("date","Open","High","Low","Close","Volume")
  # sample.xts<-select(tw50_data,-1,-7)
  # 
  # sample.xts <- as.xts(sample.xts, descr='my new xts object')
  # # colnames(sample.xts)
  # # [1] "Open"   "High"   "Low"    "Close"  "Volume" "Adj"  
  # # is.xts(sample.xts)
  
  
  #})#################################################################################################################################app END
  output1<-paste0("TW.",stockNum[i])
  assign(output1,sample.xts)
}
#result Example:
TW.2317



#setting zone 2
sample.xts<-TW.2317
#判斷式
AnalyzingFormula<-c("ma_20","ma_60")


#均線資料
ma_20<-runMean(as.numeric(sample.xts[,4]),n=20)
ma_60<-runMean(as.numeric(sample.xts[,4]),n=60)

#################################################################################################################################
{
  #判斷式
  
  AnalyzingFormula_A<-if(AnalyzingFormula[1]=="ma_20")ma_20
  AnalyzingFormula_B<-if(AnalyzingFormula[2]=="ma_60")ma_60
  
  #符合ma_20>ma_60則1(否:0),延遲一天
  position<-Lag(ifelse(AnalyzingFormula_A>AnalyzingFormula_B, 1,-1))
  #(log(今天收盤價/昨天收盤價),即10^"2.2e-02"之指數)*(是否持有:1,0)
  return<-ROC(sample.xts$Adj)*position
  
  #去除NA值
  for (i in 1:nrow(return)) {
    if(is.na(return[i])){
      j<-i
    }else{
      startisNumRow<-i;break
    }
  }
  #期間
  return<-return[startisNumRow:nrow(sample.xts)]
  
  startDate<-as.POSIXlt(time(sample.xts[startisNumRow]))
  endDate<-as.POSIXlt(time(sample.xts[nrow(sample.xts)]))
  startYear<-startDate$year+1900
  endYear<-endDate$year+1900
  startMonth<-startDate$mon+1
  endMonth<-endDate$mon+1
  startDay<-startDate$mday
  endDay<-endDate$mday
  # unlist(unclass(startDate))
  #################################################################################################################WeekRateOfReturn START
  startDate_l<-startDate
  
  # if(format(as.Date(startDate_l), "%a")=="週二")
  # unlist(unclass(as.POSIXlt(as.Date(16699))))
  # unlist(unclass(  as.POSIXlt( as.Date(16699))  ))[[7]][1]
  
  towday1<-8-unlist(unclass(startDate_l))[[7]][1]
  dayNum<-as.numeric(as.Date(startDate_l))+towday1
  
  towday1_End<-unlist(unclass(as.POSIXlt(as.Date(endDate))))[[7]][1]-1
  dayNum_end<-as.numeric(as.Date(endDate))-towday1_End
  loopNum<-(dayNum_end-dayNum)/7-1
  
  result_t<-NULL
  for (i in 0:loopNum) {
    # i=1
    #改周報酬
    
    period_Start<-as.Date(dayNum+7*i)#周一
    period_End<-as.Date(dayNum+6+7*i)#周日
    
    period<-paste(period_Start,period_End,sep = "/")
    
    #符合時間內
    # if( as.numeric(as.Date(startDate))<period_Start & period_End<as.numeric(as.Date(endDate)) ){#############符合時間內##############START
    
    return_period<-return[period]
    if(dim(return_period)[1]!=0){
      #(這裡運用國中數學:log(a)+log(b)=log(ab)，exp(log(ab))=ab)將持有期間之所有數字相乘
      assign("WeekRateOfReturn",exp(cumsum(return_period)))
      result_W<-cbind("Date"=substr(time(WeekRateOfReturn[length(WeekRateOfReturn)]),1,10),"WeekRoR"=round(WeekRateOfReturn[[length(WeekRateOfReturn)]][1],3))
      #"WeekRoR"= 到xts沒用
      result_t<-rbind(result_t,result_W)
    }
    # }##########################################################################################################符合時間內##############END
  }
  result<-as.xts(as.matrix(as.numeric(result_t[,2])),
         as.Date(result_t[,1]),
         #as.POSIXct(fr[,1], tz=Sys.getenv("TZ")),
         # src='yahoo',
         Avg=mean(as.numeric(as.matrix(result_t[,2]))),
         updated=Sys.time())
  # attr(result, "dimnames")[[2]][2]<-"WeekRoR"
  output2<-paste0("WeekRateOfReturn.",stockNum[i])
  assign(output2,result)
}
#################################################################################################################WeekRateOfReturn END
#result Example:
str(WeekRateOfReturn.NA)
# An ‘xts’ object on 2010-04-16/2016-04-08 containing:
#   Data: chr [1:308, 1] "0.976" "1.025" "1.028" "0.939" "1.029" "0.913" "0.993" "1.02" "1.051" "0.963" "1.021" "1.076" "0.929" "1" ...
# Indexed by objects of class: [Date] TZ: UTC
# xts Attributes:  
#   List of 1
# $ updated: POSIXct[1:1], format: "2016-04-17 15:30:19"
WeekRateOfReturn.NA[,1]
mean(as.numeric(WeekRateOfReturn.NA[,1]))
# [1] 1.001286
summary(WeekRateOfReturn.NA)
# Index            WeekRateOfReturn.NA
# Min.   :2010-04-16   Min.   :0.8450     
# 1st Qu.:2011-10-12   1st Qu.:0.9825     
# Median :2013-04-15   Median :1.0000     
# Mean   :2013-04-10   Mean   :1.0013     
# 3rd Qu.:2014-10-04   3rd Qu.:1.0210     
# Max.   :2016-04-08   Max.   :1.1830    
#################################################################################################################AnnualRateOfReturn START
startDate_l<-startDate
for (i in 0:) {
  #改年
  i<-0
  
  startDate_l$year+1900+i
  
  startYear_l<-startDate_l$year+1900
  startMonth_l<-startDate_l$mon+1
  startDay_l<-startDate_l$mday
  
  endYear_l<-endDate$year+1900
  endMonth_l<-endDate$mon+1
  endDay_l<-endDate$mday
  
  as.numeric(as.Date(startDate))
  endDate
  
  as.numeric(as.Date("2015-06-23"))
  
  period_Start<-"2016-01-01"
  period_End<-"2016-03-31"
  period<-"2012-10-27/2016-04-12"
  period<-paste(startYear_l,"01","01",sep = "-"),paste(startYear_l+1,"01","01",sep = "-")
  
  give.d<-as.numeric(as.Date("2016-04-19"))
  #符合時間內
  if( as.numeric(as.Date(startDate))<give.d & give.d<as.numeric(as.Date(endDate)) ){######################符合時間內##############START
    
    return_period<-return[period]
    
    #(這裡運用國中數學:log(a)+log(b)=log(ab)，exp(log(ab))=ab)將持有期間之所有數字相乘
    assign("AnnualRateOfReturn",exp(cumsum(return_period)))
    result<-cbind(result,AnnualRateOfReturn[length(rtw2317)])
    
  }##########################################################################################################符合時間內##############END
}
#################################################################################################################AnnualRateOfReturn END




#################################################################################################################################
#損益圖畫出
# plot(rtw2317,main=substr(tw50_dir[i],1,4))
# }
###############################################################################################
#圖表呈現

#K線圖
chartSeries(sample.xts)
#可縮放 選取 顯示時間
library(dygraphs)
dygraph(sample.xts[,4], main = "Stock Line") %>% 
  dyRangeSelector(dateWindow = c("2015-01-01", "2016-01-01"))


