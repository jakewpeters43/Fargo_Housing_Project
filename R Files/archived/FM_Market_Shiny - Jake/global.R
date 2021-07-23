library(tidyverse)
library(lme4)
library(caret)
library(lubridate)
library(shinyjs)
 FM_Market_Clean <- read_csv("FM_Market_Clean.csv")
 
 FM_Market_Clean[is.na(FM_Market_Clean$`Adjustment Prediction`),]$`Adjustment Prediction` <- FM_Market_Clean[is.na(FM_Market_Clean$`Adjustment Prediction`),]$`List Price`

FM_Market_Clean[FM_Market_Clean$`Book Section`=="Twinhomes",]$`Book Section`<-"Twinhome"
FM_Market_Clean[is.na(FM_Market_Clean$`Book Section`),]$`Book Section` <- "Other"

FM_Market_Clean[FM_Market_Clean$`Style`=="1 1/2 Stor",]$`Style` <- "1&frac12 Story"
FM_Market_Clean[is.na(FM_Market_Clean$`Style`),]$`Book Section` <- "Other"





# FM_Housing_Clean <- read_csv("C:/Users/13204/Documents/GitHub/FM-Housing/R Files/FM_Market_Shiny - Jake/FM_Housing_Clean.csv.gz", col_types = cols(
#   `Lease Term` = col_character(),
#   `Water Frontage Length` = col_integer(),
#   `Postal Code` = col_character(),
#   `Address #` = col_character(),
#   `Occupant Phone 2` = col_character(),
#   `Finance` = col_character(),
#   `Sheyenne Unpd` = col_character()
# ))


FM_Housing_Clean <- FM_Housing_Clean %>% mutate("Model Weight"=exp(-0.002*`Days Since Listing`))

hedonicModel <- lmer(`Log Price`~
                       #`Log List Price`+
                       `Log SqFt`+
                       
                        `Year Built`+
                       # `Building Age`+
                        `Total Bedrooms`+
                        `Total Bathrooms`+
                        `Garage Stalls`+
                        `Has Air Conditioning`+
                        `New Construction`+
                        `Style`+
                        `Roof`+
                        `Water Heater`+
                        `Kitchen Island`+
                        `Patio`+
                        `Has Deck`+
                        `Has Fence`+
                        `Sprinkler System`+
                        `Gazebo`+
                        `Pool`+
                        `Pantry`+
                        `Walk-in Closet`+
                        `Private Bath`+
                        `Spa/Hot Tub`+
                        `Foundation`+
                        `Book Section`+
                        `Exterior`+
                       (1+`Log SqFt`|`City`), data=FM_Housing_Clean, weights=`Model Weight`, REML=FALSE, control=lmerControl(calc.derivs=FALSE))

#New_Data_Clean$`Hedonic Prediction` <- exp(predict(hedonicModel, newdata=New_Data_Clean, allow.new.levels=TRUE))


