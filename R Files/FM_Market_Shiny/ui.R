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
                            min = min_listprice,
                            max = max_listprice,
                            value = c(min_listprice, max_listprice),
                            pre="$",
                            sep=",",
                            step=5000
                        ),
                        
                        sliderInput(
                            inputId = "sq_ft",
                            label = "Square Footage:",
                            min = min_sqft,
                            max = max_sqft,
                            value = c(min_sqft, max_sqft),
                            sep=",",
                            step=50
                        ),
                        
                        sliderInput(
                            inputId = "bedrooms",
                            label = "Bedrooms:", 
                            min = min_bedrooms,
                            max = max_bedrooms,
                            value = c(min_bedrooms, max_bedrooms)
                        ),
                        
                        sliderInput(
                            inputId = "bathrooms",
                            label = "Bathrooms:",
                            min = min_bathrooms,
                            max = max_bathrooms,
                            value = c(min_bathrooms, max_bathrooms),
                            step = 0.5
                        ),
                        
                        sliderInput(
                            inputId = "year_built",
                            label = "Year Built:",
                            min = min_yearbuilt,
                            max = max_yearbuilt,
                            value = c(min_yearbuilt, max_yearbuilt),
                            sep=""
                        ),
                        
                        width=3
                    ),
                    
                    mainPanel(
                        leafletOutput("map"),
                        width=9,
                        tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}")
                    )
                )
            )     
        ),
        
        fixedPanel(
            actionButton(
                inputId = "reset",
                label="Reset filters",
                icon = icon("undo"),
            ),
            
            top=80,
            right=40
        )
    )
)