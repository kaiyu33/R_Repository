#'start
#'

#install.packages("xlsx")
#library(xlsx)
library(dplyr)
#install.packages("quantmod")
library(quantmod)
#disk location
Upath<-paste0("F:/")
#file location
kgi2317_path<-paste0(Upath,"2317.csv")
#read file
#getStockNumFI<-read.csv(FI_path,encoding="big5",stringsAsFactors = FALSE)#<-big5
kgi2317<-read.csv(kgi2317_path,fileEncoding="BIG5",stringsAsFactors = FALSE)#<-UTF-8

# x_path<-"file:///C:/Users/kai/Desktop/0012.csv"
# readBin(x_path, "raw", n = 3L)
# #可查編碼BOM
# readLines(file(x_path, encoding = "BIG5"), n = 6)
# #編碼錯誤會出現錯誤訊息且不顯示

slice(kgi2317,1:5)

class(kgi2317)

kgi2317_2<-cbind(kgi2317[1],kgi2317[2],kgi2317[3],kgi2317[4],kgi2317[5])
#與colnames相同
colnames(kgi2317_2)<-c("date","Open","High","Low","Close","Volume")

macd  <- MACD( kgi2317_2[,"Close"], 12, 26, 9, maType="EMA" )
colnames(macd)

macd2  <- MACD( kgi2317_2[,"Close"], 12, 26, 9, maType="EMA" , wilder=TRUE)

sma.9<-round(SMA(kgi2317_2[,"Close"],9),2)
dsma.9<-NULL
for (i in 9:length(sma.9)-1) {
  dsma.9<-rbind(dsma.9,round(sma.9[i+1]-sma.9[i],2))
}

kgi2317_2macd<-cbind(kgi2317[16],kgi2317[17],kgi2317[18],round(macd[,1],2),round(macd[,2],2),round(macd2[,1],2),round(macd2[,2],2))
colnames(kgi2317_2macd)<-c("MACD.柱狀體.12..26..9.","DIF.12..26.","MACD.9.","macd","signal","macd2","signal2")
#"MACD.柱狀體.12..26..9."="DIF.12..26."-"MACD.9."

cbind(macd,macd2)



EMA(kgi2317_2[,"Close"], 12)


######################################################################################################################################
library(dplyr)
slice(A,1)
sapply(A, "[[",1)

#B<-sub("↓",replacement="",A$V11)
#C<-sub("↑",replacement="",B)
#刪除符號:↓,↑  @成交金額(A$V11)
#改寫成sub("↑",replacement="",sub("↓",replacement="",A$V11))

D<-mutate(A,"E"=strsplit(A$V1,"/"),"vol"=sub("↑",replacement="",sub("↓",replacement="",A$V11)))
D[[34]][[1]]<-c("year","month","day")
#class(D[[34]][[1]])="character"
#檢查:D[[34]][[1]]
F<-select(D,"time"=E,"price"=as.numeric(V5),as.numeric(vol))

G<-slice(F,2:301)

plot(x=G$vol,y=G$price)
#價量圖

line(x=G$vol,y=G$price)
model=lm(G$price~G$vol) #建立迴規模式lm(Y~X)，並命名為model

summary(model) #檢視迴歸統計量
summary.aov(model)
abline(lm(G$price~G$vol))


F1<-select(D,"price"=as.numeric(V5),as.numeric(vol),as.numeric(V2),as.numeric(V3),as.numeric(V4))
H<-select(F1,-E)
plot(F1)
attach(F1)
plot(~F1$V2,H$V3,H$V4,H$V5)

slice(F1,1:5)
sapply(D, "[[",1)
