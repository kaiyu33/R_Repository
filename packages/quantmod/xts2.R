#'packages xts
#'
#'父連結:multiquantmod_new2
#'
#'父連結:tw50ReturnOnInvestment
#'
#'
#
#install.packages("quantmod")
library(quantmod)

tw50_data

xts(x = NULL,
    order.by = index(x),
    frequency = NULL,
    unique = TRUE,
    tzone = Sys.getenv("TZ"),
    ...)

is.xts(tw50_data)

####Examples 建立xts
data(tw50_data)#180*4 time=rowname
colnames(tw50_data)
# [1] "Open"  "High"  "Low"   "Close"

rownames(tw50_data)<-tw50_data[[1]]
# [1] "2007-01-02" "2007-01-03" "2007-01-04" "2007-01-05" "2007-01-06" "2007-01-07" "2007-01-08" "2007-01-09" "2007-01-10" "2007-01-11" "2007-01-12"
# [12] "2007-01-13" "2007-01-14" "2007-01-15" "2007-01-16" "2007-01-17" "2007-01-18" "2007-01-19" "2007-01-20" "2007-01-21" "2007-01-22" "2007-01-23"
# [23] "2007-01-24" "2007-01-25" "2007-01-26" "2007-01-27" "2007-01-28" "2007-01-29" "2007-01-30" "2007-01-31" "2007-02-01" "2007-02-02" "2007-02-03"
sample.xts <- as.xts(tw50_data, descr='my new xts object')

is.xts(sample.xts)

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


str(head(xts(as.matrix(tw50_data[,-1]),#data
             as.Date(tw50_data[,1]),#rownames
             )))
# An ‘xts’ object on 2015-06-22/2015-06-29 containing:
#   Data: num [1:6, 1:7] 28.5 28.5 28.2 26.6 25.4 ...
# - attr(*, "dimnames")=List of 2
# ..$ : NULL
# ..$ : chr [1:7] "Open" "High" "Low" "Close" ...
# Indexed by objects of class: [Date] TZ: UTC
# xts Attributes:  
  NULL
str(xts(as.matrix(tw50_data[,-1]),#data
        as.Date(tw50_data[,1]),#rownames
        #detail
        src='yahoo',
        updated=Sys.time()))
# An ‘xts’ object on 2015-06-22/2016-04-15 containing:
#   Data: num [1:212, 1:7] 28.5 28.5 28.2 26.6 25.4 ...
# - attr(*, "dimnames")=List of 2
# ..$ : NULL
# ..$ : chr [1:7] "Open" "High" "Low" "Close" ...
# Indexed by objects of class: [Date] TZ: UTC
# xts Attributes:  
#   List of 2
# $ src    : chr "yahoo"
# $ updated: POSIXct[1:1], format: "2016-04-16 22:11:27"