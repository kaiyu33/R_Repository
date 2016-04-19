
#set my used packages
packages <- c(
  "dplyr",
  "Rcpp",
  "rjson",
  "shiny",
  "xlsx",
  "jsonlite",
  "httr",
  "XML",
  "AzureML",
  "datasets",
  "dygraphs",
  "quantmod"
)
sapply(packages, function(a) install.packages(a))

library(quantmod)

search()

#載入設定
# 在工作目錄的 .Rprofile

#取得工作資料夾
getwd()
#設定工作資料夾
setwd("F:/GitHub/getData/R")

#查記憶體 1.使用大小(unit:MB)
memory.size()
memory.limit()
#刪除ENV 清記憶體
rm(list=ls())

#建立資料夾
dir.create("../windows", showWarnings = FALSE)

# file.info
file.info(getStockNumCT_path2)
# size isdir mode               mtime               ctime               atime exe
# F:/EXdata/CreditTransactions/TWSECT20160104.csv 55173 FALSE  666 2016-04-10 19:27:23 2016-04-10 19:27:23 2016-04-10 19:27:23  no

#下載套件 github
library(devtools)
install_github("Rtwmap", "wush978")

#群體註解
ctrl+shift+c

#建立自動執行  不會使用
#啟動
.First<-function(){
  #建立自動執行
  #啟動
  setwd("F:/GitHub/getData/R")
  library(xlsx)
  library(dplyr)
  cat("\n Welcome!!! \n import: \n xlsx dplyr \n",format(Sys.time(), "%x %A %X \n ( %Z %z )"))
}
#結束


#開啟圖形視窗
win.graph(width=7, height=7)
#windows

#固定寬度
read.fwf

#format
x<- matrix(c(1, 2.2, 3.33, 4.4, 5.55, 6.0), nrow=3, ncol=2)
write(format(t(x), nsmall=3), ncolumns=3, file="d:/out6.txt")

#
format(t(x), nsmall=3)

#自訂函數
fun_name<- function(…){
  …
}

#demo
demo(graphics)

#遠端搜尋功能
RSiteSearch("xml")

search()
# [1] ".GlobalEnv"        "package:jsonlite"  "package:dplyr"     "package:xlsx"      "package:xlsxjars"  "package:rJava"     "package:httr"
# [8] "package:httpuv"    "tools:rstudio"     "package:stats"     "package:graphics"  "package:grDevices" "package:utils"     "package:datasets"
# [15] "package:methods"   "Autoloads"         "package:base"

#暫停幾"秒"
Sys.sleep(3)

##-- Global assignment within a function:
myf <- function(x) {
  innerf <- function(x) assign("Global.res", x^2, envir = .GlobalEnv)
  innerf(x+1)
}
myf(3)
Global.res # 16
cat(myf(3))

a <- 1:4
assign("a[1]", 2)
a[1] == 2          # FALSE
get("a[1]") == 2   # TRUE
# > a[1]
# [1] 1
# > get("a[1]")
# [1] 2
# > a <- 1:4#是影響以下
# > a[1]
# [1] 1
# > a[2]
# [1] 2
# > a[3]
# [1] 3
# > a[4]
# [1] 4
# > a[5]
# [1] NA

> split(DIRFI[i],".csv")
$.csv
[1] "1101台泥.csv"


#查已設定變數有哪些
ls()
ls(pattern = "^TW")[1]

#匯入回系統檔  但.Rprofile內的.First未起做用
sys.source(paste0(substr(getwd(),1,3),"GitHub/R_Repository/",".Rprofile"), envir = attach(NULL, name = ".Rprofile"))

#載入data 
load(paste0(substr(getwd(),1,3),"GitHub/R_Repository/",".Rdata"))

txt <- c("arm","foot","lefroo", "bafoobar")
if(length(i <- grep("foo", txt)))
  cat("'foo' appears at least once in\n\t", txt, "\n")

#字長
nchar(ED)
