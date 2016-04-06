#disk location
Upath<-paste0("F:/")
#file location
CT_path<-paste0(Upath,"1CreditTransactions.txt")
#read file
#getStockNumFI<-read.csv(FI_path,encoding="big5",stringsAsFactors = FALSE)#<-big5
# readLines(CT_path,fileEncoding="UTF-8")#<-UTF-8
# readLines(CT_path)#<-UTF-8
# read.csv(CT_path, sep =  "[")
# CT[2]

#json
fromJSON("https://api.github.com/users/hadley/repos")
CT<-head(fromJSON("http://www.tpex.org.tw/web/stock/margin_trading/margin_balance/margin_bal_result.php?l=zh-tw&_=1459953443182"))
names(CT)
#[1] "reportDate"    "iTotalRecords" "aaData"        "tfootData_one" "tfootData_two"

> CT[1]
$reportDate
[1] "105/04/06"

> CT[2]
$iTotalRecords
[1] 602