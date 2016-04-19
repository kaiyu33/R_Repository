x <- cbind(c("Tom", "Joe", "Vicky"), c(27, 29, 28))
y <- cbind(c("Tom", "Joe", "Vicky"), c(178, 186, 168))
colnames(x) <- c("name", "age")
colnames(y) <- c("name", "tall")

merge(x, y, by = "name")

merge(x, y, by = "name", all = T)
merge(x, y, by = "name", all.x = T)



dates1 <- c("02/27/92", "02/27/92", "01/14/92", "02/28/92")
as.Date(dates1, "%m/%d/%y")
dates <- c("02/03/92", "02/27/92", "01/14/92", "02/28/92")
as.Date(dates, "%m/%d/%y")

x <- cbind(as.Date(dates1, "%m/%d/%y"), c(27, 29, 28,50))
y <- cbind(as.Date(dates, "%m/%d/%y"), c(178, 186, 168,70))

x1<-xts(x[,2],as.Date(x[,1]))
y1<-xts(y[,2],as.Date(y[,1]))

cbind(x1,y1)
as.numeric(Sys.Date())
