for (A in 1999:2015) {
  for (B in 1:4) {
    #C<-A==2015
    #D<-B==4
    if(A==2015&B==4){
      break
     # print(paste0(A,"Q",B))
    }
    print(paste0(A,"Q",B))
  }
}

for (A in 1999:2015) {
  for (B in 1:4) {
    C<-A!=2015
    D<-B!=4
    if(C&D){
      print(paste0(A,"Q",B))
      break
    }
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

