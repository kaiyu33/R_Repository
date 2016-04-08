#'packages xts
#'
#install.packages("quantmod")
library(quantmod)

xts(x = NULL,
    order.by = index(x),
    frequency = NULL,
    unique = TRUE,
    tzone = Sys.getenv("TZ"),
    ...)

is.xts(x)

####Examples 建立xts
data(sample_matrix)#180*4 time=rowname
colnames(sample_matrix)
# [1] "Open"  "High"  "Low"   "Close"
rownames(sample_matrix)
# [1] "2007-01-02" "2007-01-03" "2007-01-04" "2007-01-05" "2007-01-06" "2007-01-07" "2007-01-08" "2007-01-09" "2007-01-10" "2007-01-11" "2007-01-12"
# [12] "2007-01-13" "2007-01-14" "2007-01-15" "2007-01-16" "2007-01-17" "2007-01-18" "2007-01-19" "2007-01-20" "2007-01-21" "2007-01-22" "2007-01-23"
# [23] "2007-01-24" "2007-01-25" "2007-01-26" "2007-01-27" "2007-01-28" "2007-01-29" "2007-01-30" "2007-01-31" "2007-02-01" "2007-02-02" "2007-02-03"
sample.xts <- as.xts(sample_matrix, descr='my new xts object')

str(sample.xts)
# An ‘xts’ object on 2007-01-02/2007-06-30 containing:
#   Data: num [1:180, 1:4] 50 50.2 50.4 50.4 50.2 ...
# - attr(*, "dimnames")=List of 2
# ..$ : NULL
# ..$ : chr [1:4] "Open" "High" "Low" "Close"
# Indexed by objects of class: [POSIXct,POSIXt] TZ: 
#   xts Attributes:  
#   List of 1
# $ descr: chr "my new xts object"
attr(sample.xts,'descr')
#[1] "my new xts object"



####Examples 使用&查詢 xts
getSymbols("2317.TW")
sample.xts<-`2317.TW`#

class(sample.xts)
#[1] "xts" "zoo"
str(sample.xts)
# An ‘xts’ object on 2007-01-02/2016-04-07 containing:
#   Data: num [1:2340, 1:6] 195 198 200 201 193 ...
# - attr(*, "dimnames")=List of 2
# ..$ : NULL
# ..$ : chr [1:6] "2317.TW.Open" "2317.TW.High" "2317.TW.Low" "2317.TW.Close" ...
# Indexed by objects of class: [Date] TZ: UTC
# xts Attributes:  
#   List of 2
# $ src    : chr "yahoo"
# $ updated: POSIXct[1:1], format: "2016-04-09 00:13:30"
attr(sample.xts, "dimnames") #等同於 dimnames(sample.xts)
# [[1]]
# NULL
# 
# [[2]]
# [1] "2317.TW.Open"     "2317.TW.High"     "2317.TW.Low"      "2317.TW.Close"    "2317.TW.Volume"   "2317.TW.Adjusted"
rownames(sample.xts)
# NULL

head(sample.xts)  # attribute 'descr' hidden from view
attr(sample.xts,'descr')

sample.xts['2007']  # all of 2007                                2007
sample.xts['2016-03/']  # March 2007 to the end of the data set  2016.03-
sample.xts['2007-03/2007']  # March 2007 to the end of 2007      2007.03-2007
sample.xts['/'] # the whole data set                             all
sample.xts['/2008-02'] # the beginning of the data through 2007     -2008.02
sample.xts['2007-01-03'] # just the 3rd of January 2007          2007.01.03  