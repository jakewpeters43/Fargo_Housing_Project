library(leaflet)
library(shiny)
library(shinyWidgets)
library(scales)
library(tidyverse)
library(lme4)

# dataset for our housing data we use for the Fargo-Moorhead area

FM_Market_Clean <- read_csv("FM_Market_Clean.csv")

# the adjustment prediction is predicting change from list price for our model including list price

FM_Market_Clean[is.na(FM_Market_Clean$`Adjustment Prediction`),]$`Adjustment Prediction` <- FM_Market_Clean[is.na(FM_Market_Clean$`Adjustment Prediction`),]$`List Price`

# variables for minimium and maximum house latitude and longitude

min_lon <- min(FM_Market_Clean$`Geo Lon`)
min_lat <- min(FM_Market_Clean$`Geo Lat`)
max_lon <- max(FM_Market_Clean$`Geo Lon`)
max_lat <- max(FM_Market_Clean$`Geo Lat`)

min_listprice <- 100000
max_listprice <- 1100000

min_sqft <- 1000
max_sqft <- 6000

min_bedrooms <- 1
max_bedrooms <- 8

min_bathrooms <- 1
max_bathrooms <- 8

min_yearbuilt <- 1901
max_yearbuilt <- 2021

#FM_Market_Clean[FM_Market_Clean$`Book Section`=="Twinhomes",]$`Book Section`<-"Twinhome"
#FM_Market_Clean[FM_Market_Clean$`Style`=="1 1/2 Stor",]$`Style Clean` <- "1&frac12 Story"


#========================================================================================

# loading in our hedonic model (without list price) and prediction we 
# use to predict sold price in our predictor panel

load("hedonicModel.RData")
Predicted_DF <- read_csv("Predicted_DF.csv")
