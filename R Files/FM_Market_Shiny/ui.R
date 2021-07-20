shinyUI(tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "main.css",
    navbarPage(
        inverse = TRUE,
        "Fargo-Moorhead Housing",
        tabPanel(
            "House Finder",
            fillPage(
                sidebarLayout(
                    sidebarPanel(
                        style=
                            "height: calc(100vh - 80px);
                            overflow-y: scroll;
                            margin-right: -2vh;
                            padding-right: 2vh;",
                        
                        div(style="font-size:28px; font-weight:bold;", "Selection Filters"),
                        
                        HTML('<a data-toggle="collapse" href="#basic" 
                             aria-expanded="false" aria-controls="basic">
                                 Basic info
                             <i class="fa fa-chevron-right pull-right"></i>
                                 <i class="fa fa-chevron-down pull-right"></i>
                                 </a>'),
                        
                        div(id="basic",
                            class="collapse",
                            
                            pickerInput(
                                inputId = "city",
                                label = "City:", 
                                choices = unique(na.omit(FM_Market_Clean$`City`)),
                                selected = unique(na.omit(FM_Market_Clean$`City`)),
                                options = list(`actions-box` = TRUE, height = 100), 
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
                                #choices = c("1 Story", "1 1/2 Story"="1&frac12 Story", "2 Story", "3 Story", "Bi Level", "3 Level", "4 Level"),
                                choices = unique(FM_Market_Clean$`Style`),
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
                                step=5000,
                                width="95%"
                            ),
                            
                            sliderInput(
                                inputId = "sq_ft",
                                label = "Square Footage:",
                                min = min_sqft,
                                max = max_sqft,
                                value = c(min_sqft, max_sqft),
                                sep=",",
                                step=50,
                                width="95%"
                            ),
                            
                            sliderInput(
                                inputId = "bedrooms",
                                label = "Bedrooms:", 
                                min = min_bedrooms,
                                max = max_bedrooms,
                                value = c(min_bedrooms, max_bedrooms),
                                width="95%"
                            ),
                            
                            sliderInput(
                                inputId = "bathrooms",
                                label = "Bathrooms:",
                                min = min_bathrooms,
                                max = max_bathrooms,
                                value = c(min_bathrooms, max_bathrooms),
                                step = 0.5,
                                width="95%"
                            )
                        ),
                        
                        HTML('<br><a data-toggle="collapse" href="#construction" 
                             aria-expanded="false" aria-controls="construction">
                                 Construction info
                             <i class="fa fa-chevron-right pull-right"></i>
                                 <i class="fa fa-chevron-down pull-right"></i>
                                 </a>'),
                    
                        div(
                            id="construction",
                            class="collapse",
                            
                            pickerInput(
                                inputId = "foundation",
                                label = "Foundation type:",
                                choices = unique(FM_Market_Clean$`Foundation`),
                                selected = unique(FM_Market_Clean$`Foundation`),
                                options = list(`actions-box` = TRUE),
                                multiple = TRUE
                            ),
                            
                            pickerInput(
                                inputId = "exterior",
                                label = "Exterior material:",
                                choices = unique(FM_Market_Clean$`Exterior`),
                                selected = unique(FM_Market_Clean$`Exterior`),
                                options = list(`actions-box` = TRUE),
                                multiple = TRUE
                            ),
                            
                            pickerInput(
                                inputId = "roof",
                                label = "Roof material:",
                                choices = unique(FM_Market_Clean$`Roof`),
                                selected = unique(FM_Market_Clean$`Roof`),
                                options = list(`actions-box` = TRUE),
                                multiple = TRUE
                            ),
                            
                            sliderInput(
                                inputId = "year_built",
                                label = "Year Built:",
                                min = min_yearbuilt,
                                max = max_yearbuilt,
                                value = c(min_yearbuilt, max_yearbuilt),
                                sep="",
                                width="95%"
                            )
                        ),
                                
                        width=3
                    ),
                    
                    mainPanel(
                        leafletOutput("map"),
                        tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
                        width=9
                    )
                )
            ),
            
            fixedPanel(
                actionButton(
                    inputId = "reset",
                    label="Reset filters",
                    icon = icon("undo")
                ),
                
                top=80,
                right=25
            )
        ),
        
#====================================================================================================    
    
        tabPanel("Price Predictor",
            fillPage(
                titlePanel(h1("Price Predictor", align="center")),
                
                fluidRow(column(
                    align="center",
                    width=12,
                    style="overflow-y:scroll; max-height:70vh;",
                            
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
                            step = 0.5
                        ),
                        
                        sliderInput(
                            inputId = "yearbuilt1",
                            label = "Year Built:",
                            min = 1800,
                            max = 2021,
                            value = 2021,
                            step = 1,
                            sep=""
                        ),
                            
                        numericInput(
                            inputId = "garagestalls1",
                            label = "Garage Stalls:",
                            min = 0,
                            max = 20,
                            value = 2,
                            step = 1
                                
                        ),
                            
                        pickerInput(
                            inputId = "AC1",
                            label = "Air Conditioning: ",
                            choices = unique(FM_Market_Clean$`Has Air Conditioning`),
                            selected = "Yes",
                            options = list(`actions-box` = TRUE),
                            multiple = FALSE
                        ),
                        
                        pickerInput(
                            inputId = "newconstruction1",
                            label = "New Construction: ",
                            choices = unique(FM_Market_Clean$`New Construction`),
                            selected = "Yes",
                            options = list(`actions-box` = TRUE),
                            multiple = FALSE
                        ),
                        
                        pickerInput(
                            inputId = "kitchenisland1",
                            label = "Kitchen Island: ",
                            choices = unique(FM_Market_Clean$`Kitchen Island`),
                            selected = "Yes",
                            options = list(`actions-box` = TRUE),
                            multiple = FALSE
                        ),
                        
                        pickerInput(
                            inputId = "patio1",
                            label = "Patio: ",
                            choices = unique(FM_Market_Clean$`Patio`),
                            selected = "Yes",
                            options = list(`actions-box` = TRUE),
                            multiple = FALSE
                        ),
                        
                        pickerInput(
                            inputId = "deck1",
                            label = "Deck: ",
                            choices = unique(FM_Market_Clean$`Has Deck`),
                            selected = "No",
                            options = list(`actions-box` = TRUE),
                            multiple = FALSE
                        ),
                        
                        pickerInput(
                            inputId = "fence1",
                            label = "Fence: ",
                            choices = unique(FM_Market_Clean$`Has Fence`),
                            selected = "No",
                            options = list(`actions-box` = TRUE),
                            multiple = FALSE
                        ),
                        
                        pickerInput(
                            inputId = "sprinklersystem1",
                            label = "Sprinkler System: ",
                            choices = unique(FM_Market_Clean$`Sprinkler System`),
                            selected = "Yes",
                            options = list(`actions-box` = TRUE),
                            multiple = FALSE
                        ),
                        
                        pickerInput(
                            inputId = "gazebo1",
                            label = "Gazebo: ",
                            choices = unique(FM_Market_Clean$`Gazebo`),
                            selected = "No",
                            options = list(`actions-box` = TRUE),
                            multiple = FALSE
                        ),
        
                        pickerInput(
                            inputId = "pool1",
                            label = "Pool: ",
                            choices = unique(FM_Market_Clean$`Pool`),
                            selected = "No",
                            options = list(`actions-box` = TRUE),
                            multiple = FALSE
                        ),
                        
                        pickerInput(
                            inputId = "pantry1",
                            label = "Pantry: ",
                            choices = unique(FM_Market_Clean$`Pantry`),
                            selected = "Yes",
                            options = list(`actions-box` = TRUE),
                            multiple = FALSE
                        ),
                        
                        pickerInput(
                            inputId = "walkincloset1",
                            label = "Walk-in Closet: ",
                            choices = unique(FM_Market_Clean$`Walk-in Closet`),
                            selected = "No",
                            options = list(`actions-box` = TRUE),
                            multiple = FALSE
                        ),
                        
                        pickerInput(
                            inputId = "privatebath1",
                            label = "Private Bath: ",
                            choices = unique(FM_Market_Clean$`Private Bath`),
                            selected = "No",
                            options = list(`actions-box` = TRUE),
                            multiple = FALSE
                        ),
                        
                        pickerInput(
                            inputId = "spahottub1",
                            label = "Spa/Hot Tub: ",
                            choices = unique(FM_Market_Clean$`Spa/Hot Tub`),
                            selected = "No",
                            options = list(`actions-box` = TRUE),
                            multiple = FALSE
                        ),
        
                        pickerInput(
                            inputId = "style1",
                            label = "Style: ",
                            choices = unique(FM_Market_Clean$`Style`),
                            selected = "1 Story",
                            options = list(`actions-box` = TRUE),
                            multiple = FALSE
                        ),
                        
                        pickerInput(
                            inputId = "roof1",
                            label = "Roof:",
                            choices = unique(FM_Market_Clean$`Roof`),
                            selected = "Architectural Shingle",
                            options = list(`actions-box` = TRUE),
                            multiple = FALSE
                        ),
                            
                        pickerInput(
                            inputId = "waterheater1",
                            label = "Water Heater:",
                            choices = unique(FM_Market_Clean$`Water Heater`),
                            selected = "Electric/Other",
                            options = list(`actions-box` = TRUE),
                            multiple = FALSE
                        ),
                        
                        pickerInput(
                            inputId = "foundation1",
                            label = "Foundation:",
                            choices = unique(FM_Market_Clean$`Foundation`),
                            selected = "Poured",
                            options = list(`actions-box` = TRUE),
                            multiple = FALSE
                        ),
                        
                    pickerInput(
                        inputId = "booksection1",
                        label = "House Type:",
                        choices = unique(FM_Market_Clean$`Book Section`),
                        selected = "Single Family Residence",
                        options = list(`actions-box` = TRUE),
                        multiple = FALSE
                    ),
                        
                    pickerInput(
                        inputId = "exterior1",
                        label = "House Type:",
                        choices = unique(FM_Market_Clean$`Exterior`),
                        selected = "Vinyl Siding",
                        options = list(`actions-box` = TRUE),
                        multiple = FALSE
                    )
                )),
                
                fluidRow(
                    column(width=4),
                    column(
                        width=4,
                        align="center",
                        actionButton("submit", "Submit", class = "btn-primary"),
                        verbatimTextOutput("result")
                    )
                )
            )
        )
    )
)))