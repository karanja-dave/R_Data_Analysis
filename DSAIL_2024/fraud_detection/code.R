#### Fraud Detection in Electricity and Gas Consumption Challenge

###setup
rm(list=ls()) #clear workspace
setwd("DSAIL_2024/fraud_detection") #set working directory

###load packages
library(tidymodels) #for modelling
library(dplyr) #for manipulation
library(readr) #read data fast

###data preparation
##load data
#train data
client_train<-read_csv("data/train/client_train.csv")
invoice_train<-read_csv("data/train/invoice_train.csv")
#test data
client_test<-read_csv("data/test/client_test.csv")
invoice_test<-read_csv("data/test/invoice_test.csv")

##Explore and wrange data
#wrangle function
wrangle<-function(df){
  df<-df %>%
    mutate(
      across(any_of(c("disrict", "client_catg", "region")), as.factor),
      across(any_of("target"), as.factor)
    )
  return(df)
}

#aggregrate invoice data by id
cat("Aggregation is just grouping similar data points (of same subset)\ntogether and summarizing them using their mean, sum, or count.")

agg_by_id<-function(x){
  data<-x %>% group_by(client_id) %>% 
    summarise(
    purchase_count=n(),
    mean_consommation1=mean(consommation_level_1),
    mean_consommation2=mean(consommation_level_2),
    mean_consommation3=mean(consommation_level_3),
    mean_consommation4=mean(consommation_level_4)
    
  )
  return(data)
}
#aggregrated invoice
agg_train<-agg_by_id(invoice_train)
agg_test<-agg_by_id(invoice_test)
head(agg_train)
head(agg_test)

#merge results to client data
train<-client_train %>% 
  left_join(agg_train,by="client_id")%>% 
  select(target,everything())
head(train)

test<-client_test %>% 
  left_join(agg_test,by="client_id")
head(test)

train<-wrangle(train)
test<-wrangle(test)

##split train to train and validation sets
cat("The new train set is used to train the model\n while the validation set will be used to check for overfitting")


