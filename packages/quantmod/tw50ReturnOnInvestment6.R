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
#'新增除權息資料 並於該段期間(除權息交易日 當日)持股為0 
#'自動往前抓120天 DEFAULT:300天 實際回傳為200+
#'新增每次報酬率 合併回報持有部位及報酬率 成本 淨報酬 cummax&cummin
#'
#'改版六
#'取消 cummax&cummin 請見 改版:5

#install.packages("quantmod")
# library(dplyr)
library(quantmod)


#disk location
Upath<-paste0(substr(getwd(),1,1),":/")

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
# stockNum<-tw50_dir
stockNum<-2330

from <- as.Date(as.numeric(as.Date(from,origin='1970-01-01'))-120)
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
# TW.2330


#################################################################################################################
#'Restore_Ex_dividend
#'EDxts,EDxtsC,EDxtsS
#

ED_path<-paste0(Upath,"EXdata/Ex_dividend/getStockNumED2/TW.",substr(Symbols.name,1,4),".csv")
ED<-read.csv(ED_path,stringsAsFactors = FALSE)


EDxts<-xts(as.matrix(ED[,-c(1,2)]),
           as.Date(ED[,2]),
           #as.POSIXct(fr[,1], tz=Sys.getenv("TZ")),
           src='myData',updated=Sys.time())

#################################################################################################################


#################################################################################################################
#'Backtesting
#'
#'使用資料
#'tw50ReturnOnInvestment:TW.2330
#'Restore_Ex_dividend:EDxts
#'EDxts2,EDxtsC_p,ED_C_r:需要回原檔案抓 以上不含

#setting zone 2
sample.xts<-TW.2330
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
  
  Btxts_position<-xts(as.matrix(position),
                      as.Date(time(TW.2330)),
                      #as.POSIXct(fr[,1], tz=Sys.getenv("TZ")),
                      src='myData',updated=Sys.time())
  
  for (p in 1:nrow(EDxts)) {#除權息部位為0
    if (time(TW.2330)[1]<time(EDxts[p])) {
      Btxts_position[time(EDxts[p])]<-0
    }
  }
  
  #移到  FrequencyOfReturn
  #output:startisNumRow_position  exchangeTimes  exchangeTimes_RNum  
  # #去除NA值
  # for (i in 1:nrow(Btxts_position)) {
  #   if(is.na(Btxts_position[i])){
  #     j<-i
  #   }else{
  #     startisNumRow_position<-i;break
  #   }
  # }
  # exchangeTimes<-NULL
  # exchangeTimes_RNum<-NULL
  # #exchange times
  # for (p in 1:nrow(Btxts_position)) {
  #   if(p>startisNumRow_position&p!=nrow(Btxts_position)){
  #     exchangeTimes<-rbind(exchangeTimes,abs(Btxts_position[[p]]-Btxts_position[[p+1]]))
  #     if(abs(Btxts_position[[p]]-Btxts_position[[p+1]])!=0){
  #       exchangeTimes_RNum<-cbind(exchangeTimes_RNum,p)
  #     }
  #   }else{
  #       exchangeTimes<-rbind(exchangeTimes,0)
  #   }
  # }
  # sum(exchangeTimes)
  # exchangeTimes<-cbind(exchangeTimes,cumsum(exchangeTimes))
  
  # for (m in 1:nrow(Btxts_position)) {
  #   # if (is.na(Btxts_position[m,1])) {
  #   #   0->Btxts_position[m,1]
  #   # }
  #   
  #   for (p in 1:nrow(EDxts)) {
  #     if (time(TW.2330)[1]<time(EDxts[p])) {
  #       Btxts_position[time(EDxts[p])]<-0
  #     }
  #     # 0->Btxts_position[m,1]
  #   }  
  # }
  
  #(log(今天收盤價/昨天收盤價),即10^"2.2e-02"之指數)*(是否持有:1,0)
  # return<-ROC(sample.xts$Adj)*position#use Adj
  return<-ROC(sample.xts$Close)*Btxts_position#use Close
  
  
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
  
  return_All<-exp(cumsum(return))
  
  startDate<-as.POSIXlt(time(sample.xts[startisNumRow]))
  endDate<-as.POSIXlt(time(sample.xts[nrow(sample.xts)]))
  startYear<-startDate$year+1900
  endYear<-endDate$year+1900
  startMonth<-startDate$mon+1
  endMonth<-endDate$mon+1
  startDay<-startDate$mday
  endDay<-endDate$mday
  # unlist(unclass(startDate))
}
#################################################################################################################WeekRateOfReturn START
{
  # if(format(as.Date(startDate), "%a")=="週二")
  # unlist(unclass(as.POSIXlt(as.Date(16699))))
  # unlist(unclass(  as.POSIXlt( as.Date(16699))  ))[[7]][1]
  
  towday1<-8-unlist(unclass(startDate))[[7]][1]
  dayNum<-as.numeric(as.Date(startDate))+towday1
  
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
      result_W<-cbind("Date"=paste(substr(time(WeekRateOfReturn[length(WeekRateOfReturn)]),1,10),substr(time(WeekRateOfReturn[1]),1,10),sep = " ~ "),"WeekRoR"=round(WeekRateOfReturn[[length(WeekRateOfReturn)]][1],3))
      #"WeekRoR"= 到xts沒用
      result_t<-rbind(result_t,result_W)
    }
    # }##########################################################################################################符合時間內##############END
  }
  result<-result_t
  # result<-as.xts(as.matrix(as.numeric(result_t[,2])),
  #        as.Date(result_t[,1]),
  #        #as.POSIXct(fr[,1], tz=Sys.getenv("TZ")),
  #        # src='yahoo',
  #        Avg=mean(as.numeric(as.matrix(result_t[,2]))),
  #        updated=Sys.time())
  # attr(result, "dimnames")[[2]][2]<-"WeekRoR"
  output2<-paste0("WeekRateOfReturn.",substr(Symbols.name,1,4))
  assign(output2,result)
}
#################################################################################################################WeekRateOfReturn END
{#result Example:
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
  
  
  
}
#################################################################################################################AnnualRateOfReturn START
{
  # if(format(as.Date(endDate), "%a")=="週二")
  # unlist(unclass(as.POSIXlt(as.Date(16699))))
  # unlist(unclass(  as.POSIXlt( as.Date(16699))  ))[[7]][1]
  
  year_A_S<-unlist(unclass(startDate))[[6]][1]+1900
  mon_A_S<-unlist(unclass(startDate))[[5]][1]+1
  mday_A_S<-unlist(unclass(startDate))[[4]][1]
  
  year_A_E<-unlist(unclass(endDate))[[6]][1]+1900
  mon_A_E<-unlist(unclass(endDate))[[5]][1]+1
  mday_A_E<-unlist(unclass(endDate))[[4]][1]
  
  # dayNum<-as.numeric(as.Date(endDate))+towday1
  # 
  # towday1_End<-unlist(unclass(as.POSIXlt(as.Date(endDate))))[[7]][1]-1
  # dayNum_end<-as.numeric(as.Date(endDate))-towday1_End
  loopNum<-(year_A_E-if(mon_A_E>mon_A_S){year_A_S}else if(mon_A_E==mon_A_S&mday_A_E>mday_A_S-2){year_A_S}else{year_A_S+1})
  
  result_t<-NULL
  for (i in 0:loopNum) {
    # i=1
    #改"距今一年" 年報酬
    # year_A<-unlist(unclass(endDate))[[6]][1]+1900+i
    period_Start<-paste(year_A_E-1-i,mon_A_E,mday_A_E+1,sep="-")
    period_End<-paste(year_A_E-i,mon_A_E,mday_A_E,sep="-")
    period<-paste(as.Date(as.character(period_Start)),as.Date(as.character(period_End)),sep = "/")
    
    #符合時間內
    # if( as.numeric(as.Date(startDate))<period_Start & period_End<as.numeric(as.Date(endDate)) ){#############符合時間內##############START
    
    return_period<-return[period]
    if(dim(return_period)[1]!=0){
      #(這裡運用國中數學:log(a)+log(b)=log(ab)，exp(log(ab))=ab)將持有期間之所有數字相乘
      assign("AnnualRateOfReturn",exp(cumsum(return_period)))
      result_W<-cbind("Date"=paste(substr(time(AnnualRateOfReturn[length(AnnualRateOfReturn)]),1,10),substr(time(AnnualRateOfReturn[1]),1,10),sep = " ~ "),"WeekRoR"=round(AnnualRateOfReturn[[length(AnnualRateOfReturn)]][1],3))
      #"WeekRoR"= 到xts沒用
      result_t<-rbind(result_t,result_W)
    }
    # }##########################################################################################################符合時間內##############END
  }
  result<-result_t
  # result<-as.xts(as.matrix(as.numeric(result_t[,2])),
  #                as.Date(result_t[,1]),
  #                #as.POSIXct(fr[,1], tz=Sys.getenv("TZ")),
  #                # src='yahoo',
  #                Avg=mean(as.numeric(as.matrix(result_t[,2]))),
  #                updated=Sys.time())
  
  # attr(result, "dimnames")[[2]][2]<-"WeekRoR"
  output2<-paste0("AnnualRateOfReturn.",substr(Symbols.name,1,4))
  assign(output2,result)
  
  #################################################################################################################AnnualRateOfReturn END
}


#################################################################################################################FrequencyOfReturn START
{#舊到新
  #去除NA值
  for (i in 1:nrow(Btxts_position)) {
    if(is.na(Btxts_position[i])){
      j<-i
    }else{
      startisNumRow_position<-i;break
    }
  }
  exchangeTimes<-NULL
  exchangeTimes_RNum<-NULL
  #exchange times
  for (p in 1:nrow(Btxts_position)) {
    if(p>startisNumRow_position&p!=nrow(Btxts_position)){
      exchangeTimes<-rbind(exchangeTimes,abs(Btxts_position[[p]]-Btxts_position[[p+1]]))
      if(abs(Btxts_position[[p]]-Btxts_position[[p+1]])!=0){
        exchangeTimes_RNum<-cbind(exchangeTimes_RNum,p)
      }
    }else{
      exchangeTimes<-rbind(exchangeTimes,0)
    }
  }
  sum(exchangeTimes)
  exchangeTimes<-cbind(exchangeTimes,cumsum(exchangeTimes))
  #output:exchangeTimes_RNum,exchangeTimes
  
  
  # year_A_S<-unlist(unclass(startDate))[[6]][1]+1900
  # mon_A_S<-unlist(unclass(startDate))[[5]][1]+1
  # mday_A_S<-unlist(unclass(startDate))[[4]][1]
  # 
  # year_A_E<-unlist(unclass(endDate))[[6]][1]+1900
  # mon_A_E<-unlist(unclass(endDate))[[5]][1]+1
  # mday_A_E<-unlist(unclass(endDate))[[4]][1]
  # 
  # # dayNum<-as.numeric(as.Date(endDate))+towday1
  # # 
  # # towday1_End<-unlist(unclass(as.POSIXlt(as.Date(endDate))))[[7]][1]-1
  # # dayNum_end<-as.numeric(as.Date(endDate))-towday1_End
  # loopNum<-(year_A_E-if(mon_A_E>mon_A_S){year_A_S}else if(mon_A_E==mon_A_S&mday_A_E>mday_A_S-2){year_A_S}else{year_A_S+1})
  
  result_t<-NULL
  for (i in 1:(length(exchangeTimes_RNum)-1)) {
    # i=1
    #改"距今一年" 年報酬
    # year_A<-unlist(unclass(endDate))[[6]][1]+1900+i
    period_Start<-  time(Btxts_position[exchangeTimes_RNum[i]])
    period_End<-  time(Btxts_position[exchangeTimes_RNum[i+1]])
    # period<-paste(as.Date(as.character(period_Start)),as.Date(as.character(period_End)),sep = "/")
    period<-paste(period_Start,period_End,sep = "/")
    
    #符合時間內
    # if( as.numeric(as.Date(startDate))<period_Start & period_End<as.numeric(as.Date(endDate)) ){#############符合時間內##############START
    
    return_period<-return[period]
    if(dim(return_period)[1]!=0){
      #(這裡運用國中數學:log(a)+log(b)=log(ab)，exp(log(ab))=ab)將持有期間之所有數字相乘
      assign("FrequencyOfReturn",exp(cumsum(return_period)))
      result_W<-cbind("Date"=paste(substr(time(FrequencyOfReturn[length(FrequencyOfReturn)]),1,10),
                                   substr(time(FrequencyOfReturn[1]),1,10),sep = " ~ "),
                      "FrequencyRoR"=round(FrequencyOfReturn[[length(FrequencyOfReturn)]][1],3))
      #"WeekRoR"= 到xts沒用
      result_t<-rbind(result_t,result_W)
    }
    # }##########################################################################################################符合時間內##############END
  }
  result<-result_t
  # result<-as.xts(as.matrix(as.numeric(result_t[,2])),
  #                as.Date(result_t[,1]),
  #                #as.POSIXct(fr[,1], tz=Sys.getenv("TZ")),
  #                # src='yahoo',
  #                Avg=mean(as.numeric(as.matrix(result_t[,2]))),
  #                updated=Sys.time())
  
  # attr(result, "dimnames")[[2]][2]<-"WeekRoR"
  output2<-paste0("FrequencyOfReturn.",substr(Symbols.name,1,4))
  assign(output2,result)
  
  #################################################################################################################FrequencyOfReturn END
}
#output:FrequencyOfReturn.2330  

###XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#移到  FrequencyOfReturn
{#output:startisNumRow_position  exchangeTimes  exchangeTimes_RNum  
  #去除NA值
  for (i in 1:nrow(Btxts_position)) {
    if(is.na(Btxts_position[i])){
      j<-i
    }else{
      startisNumRow_position<-i;break
    }
  }
  exchangeTimes<-NULL
  exchangeTimes_RNum<-NULL
  #exchange times
  for (p in 1:nrow(Btxts_position)) {
    if(p>startisNumRow_position&p!=nrow(Btxts_position)){
      exchangeTimes<-rbind(exchangeTimes,abs(Btxts_position[[p]]-Btxts_position[[p+1]]))
      if(abs(Btxts_position[[p]]-Btxts_position[[p+1]])!=0){
        exchangeTimes_RNum<-cbind(exchangeTimes_RNum,p)
      }
    }else{
      exchangeTimes<-rbind(exchangeTimes,0)
    }
  }
  sum(exchangeTimes)
  exchangeTimes<-cbind(exchangeTimes,cumsum(exchangeTimes))
}

{
  FrequencyOfR_position_RowNum<-(exchangeTimes_RNum[1:(length(exchangeTimes_RNum)-1)])#刪除最後持股部位 因為為最後持有狀態
  # A<-as.data.frame(Btxts_position[FrequencyOfR_position_RowNum])
  # FrequencyOfR_position=slice(A,c(nrow(A):1))
  FrequencyOfR_position_tmp<-slice(as.data.frame(Btxts_position[FrequencyOfR_position_RowNum]))
  FrequencyOfR_position<-NULL
  for (i in 1:nrow(FrequencyOfR_position_tmp)) {
    cost_type<-if(FrequencyOfR_position_tmp[i,]>0)"看多"else if(FrequencyOfR_position_tmp[i,]<0)"看空"else if(FrequencyOfR_position_tmp[i,]==0)"中立"
    FrequencyOfR_position<-rbind(FrequencyOfR_position,cost_type)
  }
  FrequencyOfR_position<-as.data.frame(FrequencyOfR_position,row.names = c(1:nrow(FrequencyOfR_position)))
  colnames(FrequencyOfR_position)<-"position"
  
  #成本 入口   出口  part1 計算進出程度
  FrequencyOfR_cost_Entrance<-NULL
  for (i in 1:nrow(FrequencyOfR_position_tmp)) {
    if(i>1){
      cost<-FrequencyOfR_position_tmp[i,1]-FrequencyOfR_position_tmp[i-1,1]
    }else if(i==1){
      cost<-FrequencyOfR_position_tmp[i,1]-0
    }
    FrequencyOfR_cost_Entrance<-rbind(FrequencyOfR_cost_Entrance,cost)
  }
  FrequencyOfR_cost_Entrance<-as.data.frame(FrequencyOfR_cost_Entrance,row.names = c(1:nrow(FrequencyOfR_cost_Entrance)))
  colnames(FrequencyOfR_cost_Entrance)<-"cost_Entrance"
  
  cost<-NULL
  FrequencyOfR_cost_Export<-NULL
  for (i in 1:nrow(FrequencyOfR_position_tmp)) {
    if(i<nrow(FrequencyOfR_position_tmp)){
      cost<-FrequencyOfR_position_tmp[i+1,1]-FrequencyOfR_position_tmp[i,1]
    }else if(i==nrow(FrequencyOfR_position_tmp)){
      cost<-FrequencyOfR_position_tmp[i,1]-0
    }
    FrequencyOfR_cost_Export<-rbind(FrequencyOfR_cost_Export,cost)
  }
  FrequencyOfR_cost_Export<-as.data.frame(FrequencyOfR_cost_Export,row.names = c(1:nrow(FrequencyOfR_cost_Export)))
  colnames(FrequencyOfR_cost_Export)<-"cost_Export"
  
  #區間數據資料
  # FrequencyNum_Start<-3
  # FrequencyNum_End<-20
  # # if(!(is.n(FrequencyNum_Start)))
  # # for (i in FrequencyNum_Start:FrequencyNum_End) {
  # #   
  # # }
  # FrequencyOfR_Accumulation<-cumprod(result[FrequencyNum_Start:FrequencyNum_End,2])
  # FrequencyOfR_Accumulation_M<-cummax(result[FrequencyNum_Start:FrequencyNum_End,2])
  # FrequencyOfR_Accumulation_m<-cummin(result[FrequencyNum_Start:FrequencyNum_End,2])
  
  FrequencyOfR_Accumulation<-cumprod(result[,2])
  FrequencyOfR_Accumulation_M_P<-cummax(result[,2])
  FrequencyOfR_Accumulation_m_P<-cummin(result[,2])
  
  FrequencyOfR_result_1_tmp<-cbind("Date"=result[,1],
                                   "FrequencyRoR"=round(as.numeric(result[,2]),3),
                                   "position"=FrequencyOfR_position,#this position not use  , useful last times write
                                   "Accumulation"=FrequencyOfR_Accumulation,
                                   "cost_Entrance"=FrequencyOfR_cost_Entrance,#this cost_Entrance not use  , useful last times write
                                   "cost_Export"=FrequencyOfR_cost_Export#this cost_Export not use  , useful last times write
                                   )
  
  
  #成本 入口   出口  part2 計算成本
  {
    ElectronicTrading<-1
    FrequencyOfR_cost_Entrance_D<-NULL
    for (i in 1:nrow(FrequencyOfR_result_1_tmp)) {
      if(i==1){
        if(FrequencyOfR_result_1_tmp[i,5]>0){
          #資金*進出量*稅率
          D<-1*FrequencyOfR_result_1_tmp[i,5]*0.001425*ElectronicTrading
        }else if(FrequencyOfR_result_1_tmp[i,5]<0){
          D<-(-1*FrequencyOfR_result_1_tmp[i,5]*(0.001425*ElectronicTrading+0.003))
        }
      }else if(i!=1){
        if(FrequencyOfR_result_1_tmp[i,5]>0){
          #資金*進出量*稅率
          D<-FrequencyOfR_result_1_tmp[(i-1),4]*FrequencyOfR_result_1_tmp[i,5]*0.001425*ElectronicTrading
        }else if(FrequencyOfR_result_1_tmp[i,5]<0){
          D<-(-FrequencyOfR_result_1_tmp[(i-1),4]*FrequencyOfR_result_1_tmp[i,5]*(0.001425*ElectronicTrading+0.003))
        }
      }
      FrequencyOfR_cost_Entrance_D<-rbind(FrequencyOfR_cost_Entrance_D,D)
    }
    # FrequencyOfR_cost_Entrance_D<-as.data.frame(cumsum(FrequencyOfR_cost_Entrance_D),row.names = c(1:nrow(FrequencyOfR_cost_Entrance_D)))
    # colnames(FrequencyOfR_cost_Entrance_D)<-"cost_Entrance"
    
    FrequencyOfR_cost_Export_D<-NULL
    for (i in 1:nrow(FrequencyOfR_result_1_tmp)) {
      if(i==1){
        if(FrequencyOfR_result_1_tmp[i,6]>0){
          #資金*進出量*稅率
          D<-1*FrequencyOfR_result_1_tmp[i,6]*0.001425*ElectronicTrading
        }else if(FrequencyOfR_result_1_tmp[i,6]<0){
          D<-(-1*FrequencyOfR_result_1_tmp[i,6]*(0.001425*ElectronicTrading+0.003))
        }
      }else if(i!=1){
        if(FrequencyOfR_result_1_tmp[i,6]>0){
          #資金*進出量*稅率
          D<-FrequencyOfR_result_1_tmp[(i-1),4]*FrequencyOfR_result_1_tmp[i,6]*0.001425*ElectronicTrading
        }else if(FrequencyOfR_result_1_tmp[i,6]<0){
          D<-(-FrequencyOfR_result_1_tmp[(i-1),4]*FrequencyOfR_result_1_tmp[i,6]*(0.001425*ElectronicTrading+0.003))
        }
      }
      FrequencyOfR_cost_Export_D<-rbind(FrequencyOfR_cost_Export_D,D)
    }
    # FrequencyOfR_cost_Export_D<-as.data.frame(cumsum(FrequencyOfR_cost_Export_D),row.names = c(1:nrow(FrequencyOfR_cost_Export_D)))
    # colnames(FrequencyOfR_cost_Export_D)<-"cost_Entrance"
    
    FrequencyOfR_cost<-(FrequencyOfR_cost_Entrance_D+FrequencyOfR_cost_Export_D)
    FrequencyOfR_cost<-as.data.frame(cumsum(FrequencyOfR_cost),row.names = c(1:length(FrequencyOfR_cost)))
    colnames(FrequencyOfR_cost)<-"cost_ALL"
  }
  
  Net_FrequencyRoR<-(FrequencyOfR_result_1_tmp[,4]-FrequencyOfR_cost)
  colnames(Net_FrequencyRoR)<-"Net_FrequencyRoR"
  
  FrequencyOfR_result_1_tmp1<-cbind(FrequencyOfR_result_1_tmp[,1:4],
                                    FrequencyOfR_cost,
                                    "Net_FrequencyRoR"=Net_FrequencyRoR)
  
  FrequencyOfR_result_1_tmp2<-slice(as.data.frame(FrequencyOfR_result_1_tmp1),c(nrow(FrequencyOfR_result_1_tmp):1))#全部反轉
  
}

#淨利 淨損 固定成本 1
for (i in 1:nrow(FrequencyOfR_result_1_tmp)) {
  if(FrequencyOfR_result_1_tmp[i,2]>1){
    if(i>1){
      NetIncome<-NetIncome+(FrequencyOfR_result_1_tmp[i,2]*FrequencyOfR_result_1_tmp[i-1,2]-1)
    }else if(i==1){
      NetIncome<-(FrequencyOfR_result_1_tmp[i,2]*1-1)
    }
  }else if(FrequencyOfR_result_1_tmp[i,2]<1){
    if(i>1){
      NetLoss<-NetLoss+(1-FrequencyOfR_result_1_tmp[i,2]*FrequencyOfR_result_1_tmp[i-1,2])
    }else if(i==1){
      NetLoss<-(1-FrequencyOfR_result_1_tmp[i,2]*1)
    }
  }
}

FrequencyOfR_result_2<-cbind("Final_position"=if(Btxts_position[[exchangeTimes_RNum[length(exchangeTimes_RNum)]]]>0)"看多"else if(Btxts_position[[exchangeTimes_RNum[length(exchangeTimes_RNum)]]]<0)"看空"else if(Btxts_position[[exchangeTimes_RNum[length(exchangeTimes_RNum)]]]==0)"中立",
                             "Accumulation_25"=round(quantile(as.numeric(result[,2]),0.25),3),
                             "Accumulation_50"=round(quantile(as.numeric(result[,2]),0.50),3),
                             "Accumulation_median"=round(median(as.numeric(result[,2])),3),
                             "Accumulation_75"=round(quantile(as.numeric(result[,2]),0.75),3),
                             "NetIncome"=round(NetIncome,3),
                             "NetLoss"=round(NetLoss,3),
                             "ProfitFactor"=round(NetIncome/NetLoss,3)
)
rownames(FrequencyOfR_result_2)<-"SUMMARY"
# #################################################################################################################################
#' ouput
#'全部   return_All
#'周   WeekRateOfReturn.2330
#'距今每一年的報酬   AnnualRateOfReturn.2330
#'每次報酬   FrequencyOfReturn.2330  FrequencyOfR_result  FrequencyOfR_result_2
# #################################################################################################################################
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


