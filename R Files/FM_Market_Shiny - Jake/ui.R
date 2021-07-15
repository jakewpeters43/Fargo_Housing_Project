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
        # tabPanel(
        #     "House Finder",
        #     fluidPage(
        #         sidebarLayout(
        #             sidebarPanel(
        #         pickerInput(
        #             inputId = "city",
        #             label = "City:",
        #             choices = unique(na.omit(FM_Market_Clean$`City`)),
        #             selected = unique(na.omit(FM_Market_Clean$`City`)),
        #             options = list(`actions-box` = TRUE),
        #             multiple = TRUE
        #         ),
        #         pickerInput(
        #             inputId = "book_section",
        #             label = "House Type:", 
        #             choices = unique(FM_Market_Clean$`Book Section`),
        #             selected = unique(FM_Market_Clean$`Book Section`),
        #             options = list(`actions-box` = TRUE), 
        #             multiple = TRUE
        #         ),
        #         sliderInput(
        #             inputId = "list_price",
        #             label = "Price Range:",
        #             min = 100000,
        #             max = 1500000,
        #             value = c(100000, 1600000),
        #             pre="$",
        #             sep=",",
        #             step = 5000
        #         ),
        #         
        #         
        #         sliderInput(
        #             inputId = "sq_ft",
        #             label = "Square Footage:",
        #             min = 750,
        #             max = 5000,
        #             value = c(750, 5000),
        #             sep=",",
        #             step = 50
        #         ),
        #         
        #         sliderInput(
        #             inputId = "bedrooms",
        #             label = "Bedrooms:",
        #             min = 0,
        #             max = 10,
        #             value = c(0,10)
        #         ),
        # 
        #         sliderInput(
        #             inputId = "bathrooms",
        #             label = "Bathrooms:",
        #             min = 0,
        #             max = 10,
        #             value = c(0,10),
        #             step = 0.5,
        # 
        #         ),
        #           width = 3, ),
        #         
        #         mainPanel(
        #         leafletOutput("map"),
        #         width = 9,
        #         tags$style(type =  "text/css", "#map {height: calc(100vh - 80px) !important;}")
        #         )
        #     )     
        # )
        #     ),
        # tabPanel(
        #         "House Predictor",
        #         fluidPage(
        #                 pickerInput(
        #                         inputId = "city",
        #                         label = "Choose Your City:",
        #                         choices = unique(na.omit(FM_Market_Clean$`City`)),
        #                         selected = unique(na.omit(FM_Market_Clean$`City`)),
        #                         options = list(`actions-box` = TRUE),
        #                         multiple = FALSE
        #                 ),   
        #                 textOutput("newdataframe")
        # )
        # ),
        tabPanel(
                "Form",
                fluidPage(
                        shinyjs::useShinyjs(),
                        shinyjs::inlineCSS(appCSS),
                        titlePanel("Mimicking a Google Form with a Shiny app"),
                        
                        div(
                                id = "form",
                                
                               # textInput("name", labelMandatory("Name"), ""),
                                pickerInput(
                                        inputId = "city1",
                                        label =("Choose Your City:"),
                                        choices = unique(na.omit(FM_Market_Clean$`City`)),
                                        selected = unique(na.omit(FM_Market_Clean$`City`)),
                                        options = list(`actions-box` = TRUE),
                                        multiple = FALSE
                                ), 
                                sliderInput(
                                        inputId = "sq_ft1",
                                        label = "Square Footage:",
                                        min = 200,
                                        max = 10000,
                                        value = c(3000),
                                        sep=",",
                                        step = 50
                                ),
                                sliderInput(
                                        inputId = "bedrooms1",
                                        label = "Bedrooms:",
                                        min = 0,
                                        max = 10,
                                        value = 5
                                ),
                                
                                sliderInput(
                                        inputId = "bathrooms1",
                                        label = "Bathrooms:",
                                        min = 0,
                                        max = 10,
                                        value = 5,
                                        step = 0.5,
                                        
                                ),
                                
                                actionButton("submit", "Submit", class = "btn-primary"),
                                renderPrint("newdataframe")
                        ),
                )
        )
        )
)


