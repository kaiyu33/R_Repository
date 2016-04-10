#'SearchPackageDownloads
library(jsonlite)

##date
# # So for dates (post-1901) from Windows Excel
# as.Date(42468, origin = "1899-12-30") # 2016-04-08
# as.numeric(as.Date("2016-04-08"))
# [1] 16899
Today<-as.Date(as.numeric(Sys.Date())+25569, origin = "1899-12-30")
TodayNum_MS<-as.numeric(Sys.Date())+25569
StartDay<-"2011-01-01"#settinggggggggggggggggggggggggggggggggggggggggggggggggggggg
StartDayNum_MS<-as.numeric(as.Date(StartDay))+25569

##查 大型封包 EX:jQuery
#path
https://api.npmjs.org/downloads/point/{period}[/{package}]
https://api.npmjs.org/downloads/range/{period}[/{package}]

Examples
period:
#期間
2014-02-01:2014-02-08
#一天
last-day
#一周 七天
last-week
#一個月 30天
last-month


##start#############################################################################################################
USearchPackage<-"jQuery"

# period<-"last-day"
period<-"last-week"
# period<-"last-month"

path0<-paste0("downloads/point/",period,"/",USearchPackage)
ptah1<-paste0("https://api.npmjs.org/", path = path0)

fromJSON(ptah1)
##END###############################################################################################################


# Badges                           /badges[/{period}]/{package}[?color={color}]
          period:{
            # 2014-02-01
            # 2014-02-01:2014-02-08
            
            last-day
            last-week
            last-month
            
            grand-total
          }
          
          ?color={
            brightgreen
            green
            yellowgreen
            yellow
            orange
            
            red
            lightgrey
            blue
          }
          Examples:
          http://cranlogs.r-pkg.org/badges/grand-total/Rcpp?color=brightgreen
          
          http://cranlogs.r-pkg.org/badges/Rcpp
          http://cranlogs.r-pkg.org/badges/last-week/Rcpp
          http://cranlogs.r-pkg.org/badges/last-day/Rcpp
          http://cranlogs.r-pkg.org/badges/Rcpp?color=brightgreen

# Top downloaded packages          /top/{period}[/count]
          http://cranlogs.r-pkg.org/top/last-day/3
          
          [/count] : 顯示前幾名

# Total downloads over a period    /downloads/total/{period}[/{package1,package2,...}]

period:{
  2014-02-01
  2014-02-01:2014-02-08
  
  last-day
  last-week
  last-month
}

package:{
  default:All packages
  
  [/{package1,package2,...}]
  igraph,ggplot2,Rcpp
}
 
#Daily downloads /downloads/daily/{period}[/{package1,package2,...}]
顯示每一日



methodods{
  
  badges{
    #使用 github : metacra/cranlogs.app
    {period:{#必要
      # 2014-02-01
      # 2014-02-01:2014-02-08
      
      last-day
      last-week
      last-month
      
      grand-total
    }
      
      ?{color={#選項
        brightgreen
        green
        yellowgreen
        yellow
        orange
        
        red
        lightgrey
        blue
      }}
    }
  }
  
  top{
    #查詢前幾名
    [/count] : 顯示前幾名#必要
  }
  
  downloads{
    #查詢下載次數
    {
      total
      #加總
      daily
      #顯示每日
    },{
      period:{#必要
        2014-02-01
        2014-02-01:2014-02-08
        
        last-day
        last-week
        last-month
      },{
        package:{
          default:All packages
          
          [/{package1,package2,...}]
          igraph,ggplot2,Rcpp
        }
      }
    }
    
  }  
}

##start#############################################################################################################

  ##date
  # # So for dates (post-1901) from Windows Excel
  # as.Date(42468, origin = "1899-12-30") # 2016-04-08
  # as.numeric(as.Date("2016-04-08"))
  # [1] 16899
  Today<-as.Date(as.numeric(Sys.Date())+25569, origin = "1899-12-30")
  TodayNum_MS<-as.numeric(Sys.Date())+25569
  StartDay<-"2011-01-01"#settinggggggggggggggggggggggggggggggggggggggggggggggggggggg
  StartDayNum_MS<-as.numeric(as.Date(StartDay))+25569
  
  ###method1
  ##Package 多請以,分隔
  USearchPackage<-"jsonlite"
  USearchPackage<-"httpuv,base64enc,RCurl,XML"
  
  ##period
  # period<-"last-day"
  period<-"last-week"
  # period<-"last-month"
  # period<-
  
  #加總
  method<-"downloads/total"
  #顯示每日
  method<-"downloads/daily"
  
  
  ###method2
  #使用 github : metacra/cranlogs.app
  
  ##period
  # period<-"last-day"
  period<-"last-week"
  # period<-"last-month"
  # period<-grand-total
  # period<-
  
  method<-badges
  
  ###method3
  #查詢前5名
  count<-5
  method<-top
  
  ###method1 use
  methodSearchPackage<-paste0(method,"/",period,"/",USearchPackage)
  ###method2 use
  methodSearchPackage<-paste0(method,"/",period,"/",USearchPackage)
  ###method3 use
  methodSearchPackage<-paste0(method,"/",count)
  
  ###search path
  ptah1<-paste0("http://cranlogs.r-pkg.org/", methodSearchPackage)
  
  datax<-fromJSON(ptah1)
  #names(datax)
  
  if(method=="downloads/total"){
    #顯示每日
    USearchPackage_l<-strsplit(USearchPackage,",")
    USearchPackage_l.lenght<-length(USearchPackage_l[[1]])
    # #顯示方法一
    # cat("Package\tdownloads\n")
    # for (i in 1:USearchPackage_l.lenght) {  cat(USearchPackage_l[[1]][i],"\t",datax$downloads[i],"\n")}
    #顯示方法二
    USearchPackage_d<-NULL#清空原始值
    for (i in 1:USearchPackage_l.lenght) {
      USearchPackage_r<-cbind(USearchPackage_l[[1]][i],datax$downloads[i])
      USearchPackage_d<-rbind(USearchPackage_d,USearchPackage_r)
    }
    USearchPackage_d
    # #顯示方法二
    # print(USearchPackage)
    # datax$downloads
  }else if(method=="downloads/daily"){
    USearchPackage_l<-strsplit(USearchPackage,",")
    USearchPackage_l.lenght<-length(USearchPackage_l[[1]])
    if(USearchPackage_l.lenght==1){
      # names(datax$downloads[[1]])
      datax$downloads[[1]]
    }else{
      cat("多個套件則顯示 總數\n")
      datax
    }
  }
  
  #ifelse(method=="downloads/total",datax$downloads,names(datax$downloads[[1]]))

##END###############################################################################################################

##start#############################################################################################################FUNCTION
SearchPackageDownloads<- function(method,period,USearchPackage){
  
  if(method=="total"){
    #加總
    method<-"downloads/total"
    ptah1<-paste0("http://cranlogs.r-pkg.org/",method,"/",period,"/",USearchPackage)
  }else if(method=="daily"){
    #顯示每日
    method<-"downloads/daily"
    ptah1<-paste0("http://cranlogs.r-pkg.org/",method,"/",period,"/",USearchPackage)
  }else{
    cat("找不到method")
  }
  # ###method2 use
  # methodSearchPackage<-paste0(method,"/",period,"/",USearchPackage)
  # ###method3 use
  # methodSearchPackage<-paste0(method,"/",count)
  
  # ###search path
  # ptah1<-paste0("http://cranlogs.r-pkg.org/", methodSearchPackage)
  
  # ##period
  # # period<-"last-day"
  # period<-"last-week"
  # # period<-"last-month"
  # # period<-
  # 
  # ##Package 多請以,分隔
  # USearchPackage<-"jsonlite"
  # USearchPackage<-"httpuv,base64enc,RCurl,XML"
  
  datax<-fromJSON(ptah1)
  #names(datax)
  
  if(method=="downloads/total"){
    #顯示每日
    USearchPackage_l<-strsplit(USearchPackage,",")
    USearchPackage_l.lenght<-length(USearchPackage_l[[1]])
    # #顯示方法一
    # cat("Package\tdownloads\n")
    # for (i in 1:USearchPackage_l.lenght) {  cat(USearchPackage_l[[1]][i],"\t",datax$downloads[i],"\n")}
    #顯示方法二
    USearchPackage_d<-NULL#清空原始值
    for (i in 1:USearchPackage_l.lenght) {
      USearchPackage_r<-cbind(USearchPackage_l[[1]][i],datax$downloads[i])
      USearchPackage_d<-rbind(USearchPackage_d,USearchPackage_r)
    }
    USearchPackage_d
    # #顯示方法二
    # print(USearchPackage)
    # datax$downloads
  }else if(method=="downloads/daily"){
    USearchPackage_l<-strsplit(USearchPackage,",")
    USearchPackage_l.lenght<-length(USearchPackage_l[[1]])
    if(USearchPackage_l.lenght==1){
      # names(datax$downloads[[1]])
      datax$downloads[[1]]
    }else{
      cat("多個套件則顯示 總數\n")
      datax
    }
  }
}
##END###############################################################################################################FUNCTION
  

SearchPackageDownloads("total","last-week","jsonlite")
SearchPackageDownloads("total","last-week","httpuv,base64enc,RCurl,XML")


library(jsonlite)
for (i in 1:length(search())) {
  if(search()[i]=="package:jsonlite"){
    if(i==length(search())){
      library(jsonlite)
    }
  }
}
search()

