#install.packages("xlsx")
library(xlsx)
library(dplyr)

runID<-NULL
for (file_year in 1999:2015) {
  for (file_QNum in 1:4) {
    runID<-cbind(runID,paste0(file_year,"Q",file_QNum))
  }
}
runIDNum<-1
#runIDNum<-6
#runIDNum<-63

#disk location
Upath<-paste0("F:/")
#file location
getStockNumFI_path<-paste0(Upath,"EXdata/FinancialInformation/FIData/",runID[runIDNum],".csv")
#read file
#getStockNumFI<-read.csv(FI_path,encoding="big5",stringsAsFactors = FALSE)#<-big5
StockFI<-read.csv(getStockNumFI_path,fileEncoding="UTF-8",stringsAsFactors = FALSE)#<-UTF-8

if (runIDNum<=5) {
  colnames(StockFI)<-c("X","ID_NAME","OR","OR_YoY","OR_Rate",
                       "Income","Income_YoY","nO_Income","nO_Income_YoY","N_Income","N_Income_YoY",
                       "N_Income_Rate","Shared","N_Income_Shared","N_Income_Shared_YoY",
                       "NetPrice_Shared","NetPrice_totalAsset","FlowRate","QuickRate" )#19欄位
  
  StockFI$"ID_NAME"<-gsub(" ",replacement="",StockFI$"ID_NAME")#取代-全部
  #sub(" ",replacement="",sub(" ",replacement="",sub(" ",replacement="",StockFI$"ID_NAME")))#取代-一次,一部分-三次還是有可能有空白
  
  Id<-substr(StockFI$"ID_NAME", 1, 4)
  Name<-substr(StockFI$"ID_NAME", 5,8)
  #H_StockFI<-head(cbind(Id,Name,Time=runID[runIDNum],select(StockFI,-1:-2,-20)))
  #準備匯出資料
  StockFI<-cbind(Id,Name,Time=runID[runIDNum],select(StockFI,-1:-2,-20,-30))
  #刪除 X ID_NAME NA
  #並建立 Id Name Time  
}



#與colnames相同
colnames(StockFI)
names(StockFI)
#　縮寫
abbreviate(names(StockFI))
# Id                Name                Time 
# "Id"              "Name"              "Time" 
# OR              OR_YoY             OR_Rate 
# "OR"              "OR_Y"              "OR_R" 
# Income          Income_YoY           nO_Income 
# "Incm"              "I_YY"             "nO_In" 
# nO_Income_YoY            N_Income        N_Income_YoY 
# "nO_I_"              "N_In"             "N_I_Y" 
# N_Income_Rate              Shared     N_Income_Shared 
# "N_I_R"              "Shrd"            "N_In_S" 
# N_Income_Shared_YoY     NetPrice_Shared NetPrice_totalAsset 
# "N_I_S_"              "NP_S"              "NP_A" 
# FlowRate           QuickRate 
# "FlwR"              "QckR" 
# 縮寫 最長四個字
abbreviate(names(StockFI),minlength = 4)
# Id                Name                Time 
# "Id"              "Name"              "Time" 
# OR              OR_YoY             OR_Rate 
# "OR"              "OR_Y"              "OR_R" 
# Income          Income_YoY           nO_Income 
# "Incm"              "I_YY"             "nO_In" 
# nO_Income_YoY            N_Income        N_Income_YoY 
# "nO_I_"              "N_In"             "N_I_Y" 
# N_Income_Rate              Shared     N_Income_Shared 
# "N_I_R"              "Shrd"            "N_In_S" 
# N_Income_Shared_YoY     NetPrice_Shared NetPrice_totalAsset 
# "N_I_S_"              "NP_S"              "NP_A" 
# FlowRate           QuickRate 
# "FlwR"              "QckR" 
#?????????????
ab[1]












