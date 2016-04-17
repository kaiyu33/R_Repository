

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
