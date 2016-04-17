#'dplyr
#'
#

order_by(10:1, cumsum(1:10))
[1] 55 54 52 49 45 40 34 27 19 10

filter(tw50_data,  Volume > 0)

arrange(tw50_data1,desc(Date))

slice(tw50_data,c(1,2,4,3))