###predicting survival rates in the titanic dataset using logistic regression and decision tree models

##clear working space and set working directory
rm(list=ls())
setwd("../survival_analysis")

##load packages
library(dplyr)
library(purrr)

##load data
path<-list.files(path="data",pattern=".csv",full.names=T)
data<-lapply(path,read.csv) %>% list_rbind()
#view first 6 rows
data %>% head()
#check data types
data %>% glimpse()
#summary statistics
data %>% summary()
#check for null values
data %>% is.na() %>% sum()
#remove null values
data<-data %>% na.omit()

#conversion to ordinal factors

data<-data %>% mutate(Pclass=as.factor(Pclass),
                Sex=as.factor(Sex),
                Embarked=as.factor(Embarked),
                Oclass=Pclass) %>% glimpse()

data$Oclass<- data$Pclass %>%sub("1","first") %>% sub("2","second") %>% sub("3","third") %>% as.factor()
data %>% glimpse()
