for (file_year in 1999:2015) {
  for (file_QNum in 1:4) {
    A<-file_year!=2015
    B<-file_QNum!=4
    if(A&B){
      break
      #print(paste0(file_year,"Q",file_QNum))
    }
    print(paste0(file_year,"Q",file_QNum))
    
  }
}




for (i in 1:3) {
  for (j in 1:10) {
    if (grepl("CODE\ *[&]\ *NAME\ *$",FinancialInformation[[i]][j])) {
      namenum<-i;
    }
  }
}

for (i in 1:3) {
  for (j in 1:10) {
    if (grepl("^\ *OPERATING\ *REVENUES\ *$",FinancialInformation[[i]][j])) {
      FInum<-i;
    }
  }
}

