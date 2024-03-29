library(tidyverse)

FM_Market_Clean <- read_csv("FM_Market_Clean.csv")

FM_Market_Clean[is.na(FM_Market_Clean$`Adjustment Prediction`),]$`Adjustment Prediction` <- FM_Market_Clean[is.na(FM_Market_Clean$`Adjustment Prediction`),]$`List Price`

FM_Market_Clean[FM_Market_Clean$`Book Section`=="Twinhomes",]$`Book Section`<-"Twinhome"
FM_Market_Clean[is.na(FM_Market_Clean$`Book Section`),]$`Book Section` <- "Other"

FM_Market_Clean[FM_Market_Clean$`Style`=="1 1/2 Stor",]$`Style` <- "1&frac12 Story"
FM_Market_Clean[is.na(FM_Market_Clean$`Style`),]$`Book Section` <- "Other"