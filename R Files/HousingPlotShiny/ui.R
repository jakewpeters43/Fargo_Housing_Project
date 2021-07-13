#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


# rsconnect::deployApp('C:\\Users\\13204\\Documents\\GitHub\\FM-Housing\\R Files\\HousingPlotShiny')
library(leaflet)
library(rsconnect)
library(shiny)
library(plotly)
library(shinyWidgets)

# Define UI for application 
shinyUI(
    
    navbarPage(inverse = TRUE, "FM_Housing",
               
tabPanel("Similar Houses",
    fluidPage(
        titlePanel("Similar Houses"),
        pickerInput(
            inputId = "city",
            label = "Choose City: ", 
            choices = unique(na.omit(FM_Housing_Clean$`City`)),
            selected = unique(na.omit(FM_Housing_Clean$`City`)),
            options = list(
                `actions-box` = TRUE), 
            multiple = TRUE
        ),
        
        sliderInput(
            inputId = "bed_slider",
            label = "Choose Number of Bedrooms: ", 
            min = 1,
            max = 7,
            value = c(1,7)
        ),
        sliderInput(
            inputId = "bath_slider",
            label = "Choose Number of Bathrooms: ",
            min = 1,
            max = 7,
            value = c(1,7),
            step = 0.5
        ),
        
        pickerInput(
            inputId = "book_section",
            label = "Choose House Type: ", 
            choices = unique(FM_Housing_Clean$`Book Section`),
            selected = unique(FM_Housing_Clean$`Book Section`),
            options = list(
                `actions-box` = TRUE), 
            multiple = TRUE
        ),
        sliderInput(
            inputId = "price_slider",
            label = "Choose a Price Range:",
            min = 40000,
            max = 700000,
            value = c(40000, 700000),

        ),
        sliderInput(
            inputId = "sq_slider",
            label = "Choose Square Feet",
            min = 100,
            max = 4000,
            value = c(100, 4000)
        ),
        # sliderInput(
        #     inputId = "year_slider",
        #     label = "Choose Year Built",
        #     min = 1600,
        #     max = 2021,
        #     value = c(1600),
        #     animate = TRUE,
        #     timeFormat = TRUE ),
        # animationOptions(
        #     interval = 5,
        #     loop = FALSE,
        #     playButton = TRUE,
        #     pauseButton = TRUE
        #     
        #     
        # ),
        
        leafletOutput("map2")
    )     
),
tabPanel("Word Cloud",
         fluidPage(sidebarLayout(position = "right",
                                 sidebarPanel(style = "background: black",
                                 wellPanel(style = "background: white",
                                           checkboxGroupInput("remarks",
                                                              "Select your Remarks(s):",
                                                              choices = 1:2,
                                                              selected = 1:2)),
                                 DT::dataTableOutput("counttable")), mainPanel( 
                                     p(strong(em("\"...It's full of flowers and heart-shaped boxes, and things we're all too young to know.\""), "1.12 - The Book of Love")),
                                     p("Unsurprisingly there's a lot of love, but what else? Hover over the word cloud below, or search for words in the table to the right:"),
                                     wordcloud2Output("wordcloud", width = "100%", height = "565px")
                                 )
         )
)
    )

)
)
