#取得工作資料夾
getwd()
#設定工作資料夾
setwd("F:/GitHub/getData/R")

#查記憶體 1.使用大小(unit:MB)
memory.size()
memory.limit()
#刪除ENV 清記憶體
rm(list=ls())

#群體註解
ctrl+shift+c

#建立自動執行  不會使用
#啟動
.First<-function()
{
  setwd("F:/GitHub/getData/R")
  library(xlsx)
  library(dplyr)
  cat("\n 歡迎!!! \n 已經為您載入: \n xlsx dplyr \n",date())
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
