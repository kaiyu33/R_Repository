#'EMA
#'
#'MACD Basic
#


#function (x, n = 10, wilder = FALSE, ratio = NULL, ...) 

  
#data
x<-kgi2317[5]
#參數
n<-12
myema<-NULL
basic<-0
ss<-0
if (n>2) {
  #
  a<-2/(n+1)
  #
  for (j in 1:nrow(x)-1) {
    i<-nrow(x)-j
    if (i!=1) {
      ss<-ss+(1-a^i)*x[i,]
      basic<-basic+(1-a^i)
    }else if(i==1) {
      ss<-ss+a*x[i,]
      basic<-basic+1
    }
    ssa<-ss/basic
  }  
}


function (x, n = 10, wilder = FALSE, ratio = NULL, ...) 
{
  x <- try.xts(x, error = as.matrix)
  if (n < 1 || n > NROW(x)) 
    stop("Invalid 'n'")
  if (any(nNonNA <- n > colSums(!is.na(x)))) 
    stop("n > number of non-NA values in column(s) ", paste(which(nNonNA), 
                                                            collapse = ", "))
  x.na <- naCheck(x, n)
  if (missing(n) && !missing(ratio)) 
    n <- trunc(2/ratio - 1)
  if (is.null(ratio)) {
    if (wilder) 
      ratio <- 1/n
    else ratio <- 2/(n + 1)
  }
  ma <- .Call("ema", x, n, ratio, PACKAGE = "TTR")
  ma <- reclass(ma, x)
  if (!is.null(dim(ma))) {
    colnames(ma) <- "EMA"
  }
  return(ma)
}
<environment: namespace:TTR>