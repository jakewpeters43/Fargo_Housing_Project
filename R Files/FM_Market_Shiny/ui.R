library(leaflet)
library(shiny)
library(shinyWidgets)

shinyUI(
    navbarPage(
        inverse = TRUE,
        "Fargo-Moorhead Housing",
        tabPanel(
            "House Finder",
            fluidPage(
                pickerInput(
                    inputId = "city",
                    label = "City:", 
                    choices = unique(na.omit(FM_Market_Clean$`City`)),
                    selected = unique(na.omit(FM_Market_Clean$`City`)),
                    options = list(`actions-box` = TRUE), 
                    multiple = TRUE
                ),
                
                pickerInput(
                    inputId = "book_section",
                    label = "House Type:", 
                    choices = unique(FM_Market_Clean$`Book Section`),
                    selected = unique(FM_Market_Clean$`Book Section`),
                    options = list(`actions-box` = TRUE), 
                    multiple = TRUE
                ),
                
                pickerInput(
                    inputId = "style",
                    label = "House style:",
                    choices = c("1 Story", "1 1/2 Story"="1&frac12 Story", "2 Story", "3 Story", "Bi Level", "3 Level", "4 Level"),
                    selected = unique(FM_Market_Clean$`Style`),
                    options = list(`actions-box` = TRUE),
                    multiple = TRUE
                ),
                
                sliderInput(
                    inputId = "list_price",
                    label = "Price Range:",
                    min = 100000,
                    max = 1600000,
                    value = c(100000, 1600000),
                    pre="$",
                    sep=",",
                    step=5000,
                ),
                
                sliderInput(
                    inputId = "sq_ft",
                    label = "Square Footage:",
                    min = 1000,
                    max = 6000,
                    value = c(1000, 6000),
                    sep=",",
                    step=50
                ),
                
                sliderInput(
                    inputId = "bedrooms",
                    label = "Bedrooms:", 
                    min = 1,
                    max = 8,
                    value = c(1,8)
                ),
                
                sliderInput(
                    inputId = "bathrooms",
                    label = "Bathrooms:",
                    min = 1,
                    max = 8,
                    value = c(1,8),
                    step = 0.5
                ),

                leafletOutput("map")
            )     
        )
    )
)