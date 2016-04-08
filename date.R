#time
Sys.time()
#[1] "2016-04-04 20:05:03 CST"
proc.time()
# user    system   elapsed 
# 11463.12      9.59 111870.56 

Sys.Date()
#[1] "2016-04-03"

date()
#[1] "Sun Apr 03 03:28:50 2016"

format(Sys.Date(), "%a %b %d")
[1] "週日 四月 03"

## read in date/time info in format 'm/d/y'
dates <- c("02/27/92", "02/27/92", "01/14/92", "02/28/92", "02/01/92")
as.Date(dates, "%m/%d/%y")
[1] "1992-02-27" "1992-02-27" "1992-01-14" "1992-02-28" "1992-02-01"


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