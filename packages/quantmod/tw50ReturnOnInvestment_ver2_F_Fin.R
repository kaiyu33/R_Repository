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

getStockData(2317,"2010-01-01","2016-04-17",autofrom=120)


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

getEDxts(2317,F)#default

###################################################################################################
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

AnalyzingFormula(TW.2317,EDxts)

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

WeekRateOfReturn(2317,startDate=startDate,endDate=endDate)

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

AnnualRateOfReturn(2317,startDate=startDate,endDate=endDate)

###################################################################################################
