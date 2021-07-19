library(leaflet)
library(shiny)
library(shinyWidgets)
library(scales)
library(tidyverse)
library(lme4)

FM_Market_Clean <- read_csv("FM_Market_Clean.csv")


FM_Market_Clean[is.na(FM_Market_Clean$`Adjustment Prediction`),]$`Adjustment Prediction` <- FM_Market_Clean[is.na(FM_Market_Clean$`Adjustment Prediction`),]$`List Price`

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

FM_Market_Clean[FM_Market_Clean$`Book Section`=="Twinhomes",]$`Book Section`<-"Twinhome"
FM_Market_Clean[FM_Market_Clean$`Style`=="1 1/2 Stor",]$`Style` <- "1&frac12 Story"


#========================================================================================

FM_Housing_Clean <- read_csv("FM_Housing_Clean.csv.gz", col_types = cols(
	`Lease Term` = col_character(),
	`Water Frontage Length` = col_integer(),
	`Postal Code` = col_character(),
	`Address #` = col_character(),
	`Occupant Phone 2` = col_character(),
	`Finance` = col_character(),
	`Sheyenne Unpd` = col_character()
))

FM_Housing_Clean <- FM_Housing_Clean %>% mutate("Model Weight"=exp(-0.002*`Days Since Listing`))

hedonicModel <- lmer(`Log Price`~
					 	`Log SqFt`+
					 	`Year Built`+
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
