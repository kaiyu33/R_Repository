GetCheckSymbolIndustry<-"   11 水泥工業  "
GetCheckSymbolCompany<-" 1101 台灣水泥  " 

regexec("^\ [0-9]{4}"," 1101 台灣水泥  " )
[[1]]
[1] 1
attr(,"match.length")
[1] 5
regexec("^\ {3}[0-9]{4}"," 1101 台灣水泥  " )
[[1]]
[1] -1
attr(,"match.length")
[1] -1

#grep
grep("^\ [0-9]{4}"," 1101 台灣水泥  " )
[1] 1
grep("^\ {3}[0-9]{4}"," 1101 台灣水泥  " )
integer(0)
grep("^\ [0-9]{4}"," 1101 台灣水泥  " )==1
[1] TRUE

#grepl
grepl("^\ [0-9]{4}"," 1101 台灣水泥  " )
[1] TRUE
grepl("^\ {3}[0-9]{4}"," 1101 台灣水泥  " )
[1] FALSE

