###################################################################################################資料
getStockData<-function(stockNum
                       ,from=NULL
                       ,to=NULL
                       ,all=F
                       ,beforeDay=300
                       ,autofrom=120
                       ,verbose=FALSE
                       ,...){
  importDefaults("getSymbols")
  #default.from 300days
  #auto input find 120days
  if(!(is.null(from)&is.null(to))&autofrom>0) from <- as.Date(as.numeric(as.Date(from,origin='1970-01-01'))-120)
  for (i in 1:length(stockNum)) {
    Symbols.name<-paste0(substr(stockNum[i],1,4),".TW")####################tw50_dir[1]  for loop
    
    #meyhod:3 make function on app
    #datasetInput <- reactive({#########################################################################################################app start
    # Symbols.name<-paste0(input$ID,".TW")####################app use
    
    
    verbose <- FALSE###############################################################################################
    tmp <- tempfile()
    on.exit(unlink(tmp))
    if((!(is.null(from)&is.null(to))) | beforeDay>0){
      # beforeDay<-300##########################取距離今天幾天前
      default.from <- as.Date(as.numeric(Sys.Date())+25569-beforeDay, origin = "1899-12-30")
    }
    
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
    if(!all){
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
    }else if(all){download.file(paste(yahoo.URL,
                                      "s=",Symbols.name,
                                      sep=''),destfile=tmp,quiet=!verbose)
    } 
    
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
    assign(output1,sample.xts,globalenv())
  }
} 

# getStockData(2317,"2010-01-01","2016-04-17",autofrom=120)
# getStockData(2317,"2014-01-01","2016-04-17",autofrom=0)
# getStockData(2317,beforeDay=300)
# getStockData(2317,all=T)

###################################################################################################資料
getEDxts<-function(stockNum,nameNum=F){
  
  ED_path<-paste0(substr(getwd(),1,1),":/","EXdata/Ex_dividend/getStockNumED2/TW.",stockNum,".csv")
  ED<-read.csv(ED_path,stringsAsFactors = FALSE)
  
  EDxts<-xts(as.matrix(ED[,-c(1,2)]),
             as.Date(ED[,2]),
             #as.POSIXct(fr[,1], tz=Sys.getenv("TZ")),
             src='myData',updated=Sys.time())
  if(nameNum)assign(paste0("EDxts.",stockNum),EDxts,globalenv())
  if(!nameNum)assign("EDxts",EDxts,globalenv())
}

# getEDxts(2317,F)#default

###################################################################################################判斷式
AnalyzingFormula<-function(stock.xts
                           ,EDxts
                           ,AnalyzingFormula_A=runMean(as.numeric(stock.xts[,4]),n=20)
                           ,AnalyzingFormula_B=runMean(as.numeric(stock.xts[,4]),n=60)
                           ,Bullish=1
                           ,Bearish=0
                           ,nameNum=F
){
  position<-Lag(ifelse(AnalyzingFormula_A>AnalyzingFormula_B, Bullish,Bearish))
  Btxts_position<-xts(as.matrix(position),
                      as.Date(time(stock.xts)),
                      #as.POSIXct(fr[,1], tz=Sys.getenv("TZ")),
                      src='myData',updated=Sys.time())
  
  for (p in 1:nrow(EDxts)) {#除權息部位為0
    if (time(stock.xts)[1]<time(EDxts[p])) {
      Btxts_position[time(EDxts[p])]<-0
    }
  }
  #(log(今天收盤價/昨天收盤價),即10^"2.2e-02"之指數)*(是否持有:1,0)
  # return<-ROC(sample.xts$Adj)*position#use Adj
  return<-ROC(stock.xts$Close)*Btxts_position#use Close
  
  #去除NA值
  for (i in 1:nrow(return)) {
    if(is.na(return[i])){
      j<-i
    }else{
      startisNumRow<-i;break
    }
  }
  #期間
  return<-return[startisNumRow:nrow(stock.xts)]
  
  return_All<-exp(cumsum(return))
  
  startDate<-as.POSIXlt(time(stock.xts[startisNumRow]))
  endDate<-as.POSIXlt(time(stock.xts[nrow(stock.xts)]))
  startYear<-startDate$year+1900
  endYear<-endDate$year+1900
  startMonth<-startDate$mon+1
  endMonth<-endDate$mon+1
  startDay<-startDate$mday
  endDay<-endDate$mday
  # unlist(unclass(startDate))
  if(!nameNum){
    assign("startDate",startDate,globalenv())
    assign("endDate",endDate,globalenv())
    assign("return",return,globalenv())
    assign("startisNumRow",startisNumRow,globalenv())
    assign("return_All",return_All,globalenv())
    assign("Btxts_position",Btxts_position,globalenv())
    
  }else if(nameNum){
    assign(paste0("startDate",substr(stock.xts,4.7)),startDate,globalenv())
    assign(paste0("endDate",substr(stock.xts,4.7)),endDate,globalenv())
    assign(paste0("return",substr(stock.xts,4.7)),return,globalenv())
  }
}

# AnalyzingFormula(TW.2317,EDxts)
# AnalyzingFormula(TW.2317,EDxts,AnalyzingFormula_A=runMean(as.numeric(TW.2317[,6]),n=20)
#                  ,AnalyzingFormula_B=runMean(as.numeric(TW.2317[,6]),n=60))
###################################################################################################
WeekRateOfReturn<-function(stockNum
                           ,startDate
                           ,endDate
){
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
  output2<-paste0("WeekRateOfReturn.",stockNum)
  assign(output2,result,globalenv())
}

# WeekRateOfReturn(2317,startDate=startDate,endDate=endDate)

###################################################################################################
AnnualRateOfReturn<-function(stockNum
                             ,startDate
                             ,endDate
){
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
  output2<-paste0("AnnualRateOfReturn.",substr(stockNum,1,4))
  assign(output2,result,globalenv())
  
  #################################################################################################################AnnualRateOfReturn END
}

# AnnualRateOfReturn(2317,startDate=startDate,endDate=endDate)

###################################################################################################
FrequencyOfReturn<-function(stockNum
                            ,startDate
                            ,endDate
){#舊到新
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
      if(abs(Btxts_position[[p-1]]-Btxts_position[[p]])!=0){
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
      result_W<-cbind("Date"=paste(substr(time(FrequencyOfReturn[1]),1,10),
                                   substr(time(FrequencyOfReturn[length(FrequencyOfReturn)]),1,10)
                                   ,sep = " ~ "),
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
  output2<-paste0("FrequencyOfReturn.",substr(stockNum,1,4))
  assign(output2,result,globalenv())
  
  #################################################################################################################FrequencyOfReturn END
}

# FrequencyOfReturn(2317,startDate=startDate,endDate=endDate)

###################################################################################################Report
FrequencyOfReturn_Report<-function(result
                                   ,Btxts_position
                                   ,ElectronicTrading=1
){
  #新增交易次數
  #移到  FrequencyOfReturn
  #output:startisNumRow_position  exchangeTimes  exchangeTimes_RNum  
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
  
  FrequencyOfR_position_RowNum<-(exchangeTimes_RNum[(1+1):length(exchangeTimes_RNum)])#刪除最後持股部位 因為為最後持有狀態
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
  
  #成本 計算
  
  FrequencyOfR_cost_Entrance<-NULL
  for (i in 1:nrow(FrequencyOfR_position_tmp)) {
    cost<-if(FrequencyOfR_position_tmp[i,]>0){
      FrequencyOfR_position_tmp[i,]*FrequencyOfR_Accumulation[i]*0.001425*ElectronicTrading
    }else if(FrequencyOfR_position_tmp[i,]<0){
      -(FrequencyOfR_position_tmp[i,]*FrequencyOfR_Accumulation[i]*(0.001425*ElectronicTrading+0.003))
    }else if(FrequencyOfR_position_tmp[i,]==0){
      0
    }
    FrequencyOfR_cost_Entrance<-rbind(FrequencyOfR_cost_Entrance,cost)
  }
  
  cost<-NULL
  FrequencyOfR_cost_Export<-NULL
  for (i in 1:nrow(FrequencyOfR_position_tmp)) {
    cost<-if(FrequencyOfR_position_tmp[i,]>0){
      FrequencyOfR_position_tmp[i,]*FrequencyOfR_Accumulation[i]*(0.001425*ElectronicTrading+0.003)
    }else if(FrequencyOfR_position_tmp[i,]<0){
      -(FrequencyOfR_position_tmp[i,]*FrequencyOfR_Accumulation[i]*0.001425*ElectronicTrading)
    }else if(FrequencyOfR_position_tmp[i,]==0){
      0
    }
    FrequencyOfR_cost_Export<-rbind(FrequencyOfR_cost_Export,cost)
  }
  
  FrequencyOfR_cost_Each<-c(FrequencyOfR_cost_Entrance+FrequencyOfR_cost_Export)
  FrequencyOfR_cost_Each<-as.data.frame(FrequencyOfR_cost_Each,optional = T)
  colnames(FrequencyOfR_cost_Each)<-"Each_cost"
  
  FrequencyOfR_cost_Accumulation<-cumsum(FrequencyOfR_cost_Entrance+FrequencyOfR_cost_Export)
  FrequencyOfR_cost_Accumulation<-as.data.frame(FrequencyOfR_cost_Accumulation,optional = T)
  colnames(FrequencyOfR_cost_Accumulation)<-"Accumulation_cost"
  
  #Net_FrequencyRoR
  Net_FrequencyRoR<-(FrequencyOfR_Accumulation-FrequencyOfR_cost_Each)
  colnames(Net_FrequencyRoR)<-"Net_FrequencyRoR"
  
  FrequencyOfR_result_1_tmp<-cbind("Date"=result[,1],
                                   "FrequencyRoR"=round(as.numeric(result[,2]),3),
                                   "position"=FrequencyOfR_position,#this position not use  , useful last times write
                                   "Accumulation"=FrequencyOfR_Accumulation,
                                   FrequencyOfR_cost_Each,
                                   FrequencyOfR_cost_Accumulation,
                                   "Net_FrequencyRoR"=Net_FrequencyRoR
  )
  
  FrequencyOfR_result<-slice(as.data.frame(FrequencyOfR_result_1_tmp),c(nrow(FrequencyOfR_result_1_tmp):1))#全部反轉
  assign("FrequencyOfReturn_Report1",FrequencyOfR_result,globalenv())
  
  ###################################################################################################Report2
  #淨利 淨損 固定成本 1
  NetIncome<-0
  NetLoss<-0
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
  assign("FrequencyOfReturn_Report2",FrequencyOfR_result_2,globalenv())
}

# FrequencyOfReturn_Report(FrequencyOfReturn.2317,Btxts_position=Btxts_position)
