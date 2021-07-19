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
    )
)))