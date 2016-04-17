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

#取距離今天幾天前
beforeDay<-200
as.Date(as.numeric(Sys.Date())+25569-beforeDay, origin = "1899-12-30")

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
## locale-specific version of date()
format(Sys.time(), "%a %b %d %X %Y %Z")

## time to sub-second accuracy (if supported by the OS)
format(Sys.time(), "%H:%M:%OS3")

## read in date info in format 'ddmmmyyyy'
## This will give NA(s) in some locales; setting the C locale
## as in the commented lines will overcome this on most systems.
## lct <- Sys.getlocale("LC_TIME"); Sys.setlocale("LC_TIME", "C")
x <- c("1jan1960", "2jan1960", "31mar1960", "30jul1960")
z <- strptime(x, "%d%b%Y")
## Sys.setlocale("LC_TIME", lct)
z

## read in date/time info in format 'm/d/y h:m:s'
dates <- c("02/27/92", "02/27/92", "01/14/92", "02/28/92", "02/01/92")
times <- c("23:03:20", "22:29:56", "01:03:30", "18:21:03", "16:56:26")
x <- paste(dates, times)
strptime(x, "%m/%d/%y %H:%M:%S")

## time with fractional seconds
z <- strptime("20/2/06 11:16:16.683", "%d/%m/%y %H:%M:%OS")
z # prints without fractional seconds
op <- options(digits.secs = 3)
z
options(op)

## time zones name are not portable, but 'EST5EDT' comes pretty close.
(x <- strptime(c("2006-01-08 10:07:52", "2006-08-07 19:33:02"),
               "%Y-%m-%d %H:%M:%S", tz = "EST5EDT"))
attr(x, "tzone")

## An RFC 822 header (Eastern Canada, during DST)
strptime("Tue, 23 Mar 2010 14:36:38 -0400",  "%a, %d %b %Y %H:%M:%S %z")

## Make sure you know what the abbreviated names are for you if you wish
## to use them for input (they are matched case-insensitively):
format(seq.Date(as.Date('1978-01-01'), by = 'day', len = 7), "%a")
# [1] "週日" "週一" "週二" "週三" "週四" "週五" "週六"
format(seq.Date(as.Date('2000-01-01'), by = 'month', len = 12), "%b")
# [1] "一月"   "二月"   "三月"   "四月"   "五月"   "六月"   "七月"   "八月"   "九月"   "十月"   "十一月" "十二月"

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

##########################################################################################
startDate<-as.POSIXlt(time(sample.xts[startisNumRow]))
unlist(unclass(startDate))
# sec   min  hour  mday   mon  year  wday  yday isdst 
# 0     0     0    15     8   115     2   257     0 
unlist(unclass(startDate_l))[7]
# wday 
# 2 
unlist(unclass(startDate_l))[7]==2
# wday 
# TRUE 

(z <- Sys.time())             # the current datetime, as class "POSIXct"
unclass(z)                    # a large integer
floor(unclass(z)/86400)       # the number of days since 1970-01-01 (UTC)
(now <- as.POSIXlt(Sys.time())) # the current datetime, as class "POSIXlt"
unlist(unclass(now))          # a list shown as a named vector
now$year + 1900               # see ?DateTimeClasses
months(now); weekdays(now)    # see ?months

## suppose we have a time in seconds since 1960-01-01 00:00:00 GMT
## (the origin used by SAS)
z <- 1472562988
# ways to convert this
as.POSIXct(z, origin = "1960-01-01")                # local
as.POSIXct(z, origin = "1960-01-01", tz = "GMT")    # in UTC

## SPSS dates (R-help 2006-02-16)
z <- c(10485849600, 10477641600, 10561104000, 10562745600)
as.Date(as.POSIXct(z, origin = "1582-10-14", tz = "GMT"))

## Stata date-times: milliseconds since 1960-01-01 00:00:00 GMT
## format %tc excludes leap-seconds, assumed here
## For format %tC including leap seconds, see foreign::read.dta()
z <- 1579598122120
op <- options(digits.secs = 3)
# avoid rounding down: milliseconds are not exactly representable
as.POSIXct((z+0.1)/1000, origin = "1960-01-01")
options(op)

## Matlab 'serial day number' (days and fractional days)
z <- 7.343736909722223e5 # 2010-08-23 16:35:00
as.POSIXct((z - 719529)*86400, origin = "1970-01-01", tz = "UTC")

as.POSIXlt(Sys.time(), "GMT") # the current time in UTC

## These may not be correct names on your system
as.POSIXlt(Sys.time(), "America/New_York")  # in New York
as.POSIXlt(Sys.time(), "EST5EDT")           # alternative.
as.POSIXlt(Sys.time(), "EST" )   # somewhere in Eastern Canada
as.POSIXlt(Sys.time(), "HST")    # in Hawaii
as.POSIXlt(Sys.time(), "Australia/Darwin")


cols <- c("code", "coordinates", "TZ", "comments")
tmp <- read.delim(file.path(R.home("share"), "zoneinfo", "zone.tab"),
                  header = FALSE, comment.char = "#", col.names = cols)
if(interactive()) View(tmp)