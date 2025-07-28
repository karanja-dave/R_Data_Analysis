#set working directory
setwd("../DSAIL_2024")

###importation
##reading zipped files
#View zipped files
unzip("data/train.zip",list=T)
client_test<-read.csv(unz("data/test.zip","client_test.csv"))
cat("the unz() extracts the zipped file bila kuistore in my machine")

###exploration and cleaning
#check for same col names
same_col<-function(x,y){
  ifelse(identical(names(x),names(y)),T,
         union(setdiff(names(x),names(y)),setdiff(names(y),names(x))))
}
#check for similarity in data types and cardinality length
same_dtype<-function(x,y){
  common<-intersect(names(x),names(y))
  lapply(common,\(col)
         c(type=typeof(x[[col]])==typeof(y[[col]]),
           eq_card=length(unique(x[[col]]))==length(unique(y[[col]]))))%>%
    setNames(common)
}
same_col(client_test,client_train)
same_col(invoice_train,invoice_test)
same_dtype(client_test,client_train)
same_dtype(invoice_train,invoice_test)
