#time

format(Sys.time())
# [1] "2016-04-13 05:06:05"

format(Sys.time(), "%x %A %X %Z %z")
# [1] "2016/4/13 星期三 上午 05:04:58 CST +0800"

format(Sys.time(), "%Y/%m/%d")
#[1] "2016/04/13"

############################################################################################

Sys.time()
#[1] "2016-04-04 20:05:03 CST"
proc.time()
# user    system   elapsed 
# 11463.12      9.59 111870.56 

Sys.Date()
#[1] "2016-04-03"

date()
#[1] "Sun Apr 03 03:28:50 2016"

format(Sys.time(), "%a %b %c %d")
 

format(Sys.Date(), "%a %b %d")
     "%a %b %d"
[1] "週日 四月 03"

## read in date/time info in format 'm/d/y'
dates <- c("02/27/92", "02/27/92", "01/14/92", "02/28/92", "02/01/92")
as.Date(dates, "%m/%d/%y")
[1] "1992-02-27" "1992-02-27" "1992-01-14" "1992-02-28" "1992-02-01"

#
as.numeric(as.Date("2016-04-08"))
#[1] 16899

## So for dates (post-1901) from Windows Excel
as.Date(35981, origin = "1899-12-30") # 1998-07-05
as.Date(35982, origin = "1899-12-30")

## and Mac Excel
as.Date(34519, origin = "1904-01-01") # 1998-07-05


## Time zone effect
z <- ISOdate(2010, 04, 13, c(0,12)) # midnight and midday UTC
as.Date(z) # in UTC
## these time zone names are common
as.Date(z, tz = "NZ")
as.Date(z, tz = "HST") # Hawaii


#計算距今幾天
as.numeric(as.Date("2011-01-01"))-as.numeric(as.Date(as.numeric(Sys.Date())+25569, origin = "1899-12-30"))

##########################################################################################


format(Sys.time(), "%X")
#[1] "上午 04:55:09"
format(Sys.time(), "%x")
#[1] "2016/4/13"

format(Sys.time(), "%A")
##[1] "星期三"
format(Sys.time(), "%a ")
##[1] "週三 "

format(Sys.time(), "%Z")
#[1] "CST"
format(Sys.time(), "%z")
#[1] "+0800"

##########################################################################################
format(Sys.time(), "%A")
##[1] "星期三"
format(Sys.time(), "%a ")
##[1] "週三 "

format(Sys.time(), "%B")
##[1] "四月"
format(Sys.time(), "%b")
##[1] "四月"

format(Sys.time(), "%c")
##[1] "週三 四月 13 04:52:01 2016"

format(Sys.time(), "%D")
##[1] "04/13/16"
format(Sys.time(), "%d")
##[1] "13"

format(Sys.time(), "%e")
##[1] "13"
#Day of the month as decimal number (1–31), with a leading space for a single-digit number.

format(Sys.time(), "%v")
#[1] "13-四月-2016"

format(Sys.time(), "%W")
#[1] "15"

format(Sys.time(), "%X")
#[1] "上午 04:55:09"
format(Sys.time(), "%x")
#[1] "2016/4/13"

format(Sys.time(), "%Y")
#[1] "2016"
format(Sys.time(), "%y")
#[1] "16"

format(Sys.time(), "%Z")
#[1] "CST"
format(Sys.time(), "%z")
#[1] "+0800"
