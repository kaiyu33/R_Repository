#'continue write
#disk location
Upath<-paste0("D:/")
new_path00<-paste0(Upath,"xxx.csv")

a<-tw2317[1,]
  
write.csv(a,file = new_path00)


a1<-read.csv(new_path00,fileEncoding="UTF-8",stringsAsFactors = FALSE)#<-UTF-8
a1

for (i in 1:100) {
  a1<-read.csv(new_path00,fileEncoding="UTF-8",stringsAsFactors = FALSE)#<-UTF-8
  a1<-select(a1,-1)
  print(a1)
  # X<-i
  # b1<-cbind(X,tw2317[i,])
  a1<-rbind(a1,tw2317[i,])
  
  write.csv(a1,file = new_path00)
}
