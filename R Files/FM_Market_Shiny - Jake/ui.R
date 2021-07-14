library(leaflet)
library(shiny)
library(shinyWidgets)
library(shinydashboard)



# Define UI for application 
shinyUI(
   # navbarPage(
        # dashboardPage(
        #     dashboardHeader(title = "Nutrition Calculator"),
        #     dashboardSidebar(
        #     ),
        #     dashboardBody(
                navbarPage(
                    inverse = TRUE,
        #inverse = TRUE,
        "Fargo-Moorhead Housing",
        tabPanel(
            "House Finder",
            fluidPage(
                sidebarLayout(
                    sidebarPanel(
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
                sliderInput(
                    inputId = "list_price",
                    label = "Price Range:",
                    min = 100000,
                    max = 1500000,
                    value = c(100000, 1600000),
                    pre="$",
                    sep=",",
                    step = 5000
                ),
                
                
                sliderInput(
                    inputId = "sq_ft",
                    label = "Square Footage:",
                    min = 750,
                    max = 5000,
                    value = c(750, 5000),
                    sep=",",
                    step = 50
                ),
                
                sliderInput(
                    inputId = "bedrooms",
                    label = "Bedrooms:", 
                    min = 0,
                    max = 10,
                    value = c(0,10)
                ),
                
                sliderInput(
                    inputId = "bathrooms",
                    label = "Bathrooms:",
                    min = 0,
                    max = 10,
                    value = c(0,10),
                    step = 0.5
                )
                    ),
                
                mainPanel(
                leafletOutput("map")
                )
            )     
        )
            )
            )
)



