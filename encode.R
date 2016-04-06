x <- A[2,17]
Encoding(x)
Encoding(x)<-"UTF-8"

#
Encoding("\u5176")
[1] "UTF-8"

#
cat(encodeString("\u5176"), "\n", sep = "")
其

x
y<-" "
Encoding(y)<-"UTF-8"
y
enc2utf8(y)
A[2,18]==y

enc2utf8(" ")==A[2,18]
