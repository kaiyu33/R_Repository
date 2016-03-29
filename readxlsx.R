#this file location F:/getData

#install.packages("gdata")
#library(gdata)
#remove.packages("gdata")
#'解安裝 我不會使用 但是xlsx可以正常使用
#'require(gdata)
#'df = read.xls ("myfile.xlsx"), sheet = 1, header = TRUE)
#'xls2csv(xls, sheet=1, verbose=FALSE, blank.lines.skip=TRUE,perl="F:/1999Q1.xls")


#install.packages("xlsx")
library(xlsx)
#disk location
Upath<-paste0("F:/")
#file location
FinancialInformationPath<-paste0(Upath,"1999Q1.xls")
FinancialInformation<-read.xlsx(FinancialInformationPath,1,encoding="UTF-8",stringsAsFactors = FALSE)