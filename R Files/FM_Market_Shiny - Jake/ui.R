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
        #             choices = unique(na.omit(FM_Housing_Clean$`City`)),
        #             selected = unique(na.omit(FM_Housing_Clean$`City`)),
        #             options = list(`actions-box` = TRUE),
        #             multiple = TRUE
        #         ),
        #         pickerInput(
        #             inputId = "book_section",
        #             label = "House Type:", 
        #             choices = unique(FM_Housing_Clean$`Book Section`),
        #             selected = unique(FM_Housing_Clean$`Book Section`),
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
        #                         choices = unique(na.omit(FM_Housing_Clean$`City`)),
        #                         selected = unique(na.omit(FM_Housing_Clean$`City`)),
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
                        HTML("<button type='button' class='btn' data-toggle='collapse' data-target='#form1'> More Information</button>"),
                        HTML("<button type='button' class='btn' data-toggle='collapse' style='float:left' data-target='#form2'><span class='glyphicon glyphicon-collapse-down'></span> More Information</button>"),
                        HTML("<button type='button' class='btn' data-toggle='collapse' style='float:left' data-target='#form3'><span class='glyphicon glyphicon-collapse-down'></span> More Information</button>"),
                        HTML("<button type='button' class='btn' data-toggle='collapse' style='float:left' data-target='#form4'><span class='glyphicon glyphicon-collapse-down'></span> More Information</button>"),
                        div(
                                id = "form1", class = "collapse out",
                                
                               # textInput("name", labelMandatory("Name"), ""),
                                pickerInput(
                                        inputId = "city1",
                                        label =("Choose Your City:"),
                                        choices = unique(na.omit(FM_Housing_Clean$`City`)),
                                        selected = unique(na.omit(FM_Housing_Clean$`City`)),
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
                               sliderInput(
                                       inputId = "yearbuilt1",
                                       label = "Year Built:",
                                       min = 1800,
                                       max = 2021,
                                       value = 2021,
                                       step = 1,
                               )
                                ),
                               div(
                                       id = "form2", class = "collapse out", 
                                          
                              numericInput(
                                       inputId = "garagestalls1",
                                       label = "Garage Stalls:",
                                       min = 0,
                                       max = 20,
                                       value = 2,
                                       step = 1,
                               
                                ),
                         
                               pickerInput(
                                       inputId = "AC1",
                                       label = "Air Conditioning: ",
                                       choices = unique(FM_Housing_Clean$`Has Air Conditioning`),
                                       selected = "Yes",
                                       options = list(`actions-box` = TRUE),
                                       multiple = FALSE
                               ),
                               pickerInput(
                                       inputId = "newconstruction1",
                                       label = "New Construction: ",
                                       choices = unique(FM_Housing_Clean$`New Construction`),
                                       selected = "Yes",
                                       options = list(`actions-box` = TRUE),
                                       multiple = FALSE
                               ),
                               pickerInput(
                                       inputId = "kitchenisland1",
                                       label = "Kitchen Island: ",
                                       choices = unique(FM_Housing_Clean$`Kitchen Island`),
                                       selected = "Yes",
                                       options = list(`actions-box` = TRUE),
                                       multiple = FALSE
                               ),
                               pickerInput(
                                       inputId = "patio1",
                                       label = "Patio: ",
                                       choices = unique(FM_Housing_Clean$`Patio`),
                                       selected = "Yes",
                                       options = list(`actions-box` = TRUE),
                                       multiple = FALSE
                               ),
                               pickerInput(
                                       inputId = "deck1",
                                       label = "Deck: ",
                                       choices = unique(FM_Housing_Clean$`Has Deck`),
                                        selected = "No",
                                       options = list(`actions-box` = TRUE),
                                       multiple = FALSE
                               ),
                               pickerInput(
                                       inputId = "fence1",
                                       label = "Fence: ",
                                       choices = unique(FM_Housing_Clean$`Has Fence`),
                                       selected = "No",
                                       options = list(`actions-box` = TRUE),
                                       multiple = FALSE
                               ),
                               pickerInput(
                                       inputId = "sprinklersystem1",
                                       label = "Sprinkler System: ",
                                       choices = unique(FM_Housing_Clean$`Sprinkler System`),
                                       selected = "Yes",
                                       options = list(`actions-box` = TRUE),
                                       multiple = FALSE
                               ),
                               pickerInput(
                                       inputId = "gazebo1",
                                       label = "Gazebo: ",
                                       choices = unique(FM_Housing_Clean$`Gazebo`),
                                       selected = "No",
                                       options = list(`actions-box` = TRUE),
                                       multiple = FALSE
                               ),
                        ),
                        div(
                                id = "form3", class = "collapse out",
                               pickerInput(
                                       inputId = "pool1",
                                       label = "Pool: ",
                                       choices = unique(FM_Housing_Clean$`Pool`),
                                       selected = "No",
                                       options = list(`actions-box` = TRUE),
                                       multiple = FALSE
                               ),
                               pickerInput(
                                       inputId = "pantry1",
                                       label = "Pantry: ",
                                       choices = unique(FM_Housing_Clean$`Pantry`),
                                       selected = "Yes",
                                       options = list(`actions-box` = TRUE),
                                       multiple = FALSE
                               ),
                               pickerInput(
                                       inputId = "walkincloset1",
                                       label = "Walk-in Closet: ",
                                       choices = unique(FM_Housing_Clean$`Walk-in Closet`),
                                       selected = "No",
                                       options = list(`actions-box` = TRUE),
                                       multiple = FALSE
                               ),
                               pickerInput(
                                       inputId = "privatebath1",
                                       label = "Private Bath: ",
                                       choices = unique(FM_Housing_Clean$`Private Bath`),
                                       selected = "No",
                                       options = list(`actions-box` = TRUE),
                                       multiple = FALSE
                               ),
                               pickerInput(
                                       inputId = "spahottub1",
                                       label = "Spa/Hot Tub: ",
                                       choices = unique(FM_Housing_Clean$`Spa/Hot Tub`),
                                       selected = "No",
                                       options = list(`actions-box` = TRUE),
                                       multiple = FALSE
                               ),
                        ),
                               div(
                                       id = "form4", class = "collapse out",
                               
                               pickerInput(
                                       inputId = "style1",
                                       label = "Style: ",
                                       choices = unique(FM_Housing_Clean$`Style`),
                                       selected = "1 Story",
                                       options = list(`actions-box` = TRUE),
                                       multiple = FALSE
                               ),
                               pickerInput(
                                       inputId = "roof1",
                                       label = "Roof:",
                                       choices = unique(FM_Housing_Clean$`Roof`),
                                       selected = "Architectural Shingle",
                                       options = list(`actions-box` = TRUE),
                                       multiple = FALSE
                               ),
                               pickerInput(
                                       inputId = "waterheater1",
                                       label = "Water Heater:",
                                       choices = unique(FM_Housing_Clean$`Water Heater`),
                                       selected = "Electric/Other",
                                       options = list(`actions-box` = TRUE),
                                       multiple = FALSE
                               ),
                               pickerInput(
                                       inputId = "foundation1",
                                       label = "Foundation:",
                                       choices = unique(FM_Housing_Clean$`Foundation`),
                                       selected = "Poured",
                                       options = list(`actions-box` = TRUE),
                                       multiple = FALSE
                               ),
                               pickerInput(
                                       inputId = "booksection1",
                                       label = "House Type:",
                                       choices = unique(FM_Housing_Clean$`Book Section`),
                                       selected = "Single Family Residence",
                                       options = list(`actions-box` = TRUE),
                                       multiple = FALSE
                               ),
                               pickerInput(
                                       inputId = "exterior1",
                                       label = "House Type:",
                                       choices = unique(FM_Housing_Clean$`Exterior`),
                                       selected = "Vinyl Siding",
                                       options = list(`actions-box` = TRUE),
                                       multiple = FALSE
                               ),
                        ),
                              
                        
                               mainPanel(
                         actionButton("submit", "Submit", class = "btn-primary"),
                                verbatimTextOutput("result"),
                               verbatimTextOutput("value"),
                        
                        ),
                )
        )
        )
)


