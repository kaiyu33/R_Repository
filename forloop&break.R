#forloop
for (i in 1:3) {
  for (j in 1:10) {
    if (i*j==6) {
      break;
    }else{
      print(paste(i,j))
    }
  }
}

# [1] "1 1"
# [1] "1 2"
# [1] "1 3"
# [1] "1 4"
# [1] "1 5"
# [1] "2 1"
# [1] "2 2"
# [1] "3 1"

#
for (i in 1:6) {
  n<- paste("x",i,sep=".")
  assign(n,1:i)
}
x.1
ls(pattern = "^x..$")
# [1] "x.1" "x.2" "x.3" "x.4" "x.5" "x.6"

#
%in%

#get("變數名稱")
x=c(11,12,13)
y=100
s1="x"
s2=c("x","y")

get(s1)
#[1] 11 12 13
get(s1)[2]
#[1] 12
get(s2[1])
#[1] 11 12 13
get(s2[2])
#[1] 100

#設定值 取代 運算
#相同
assign("x",2+2)
x<-4

#
a=100
list(b=2)
# $b
# [1] 2
substitute(a+b,list(b=2))
#a + 2
eval(substitute(a+b,list(b=2)))
#[1] 102

#
lm(y~x+a)
v=c("a","b","c")
eval(substitute(lm(y~x+z),list(z=as.name(v[1]))))

#p.295???????????????????????????????
# #install.packages("tutoR")
# Installing package into ‘C:/Users/kai/Documents/R/win-library/3.2’
# (as ‘lib’ is unspecified)
# Warning in install.packages :
#   package ‘tutoR’ is not available (for R version 3.2.4 Revised)
# library("tutoR")
# eval.stg("x<- =1")
