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
            choices = unique(na.omit(Houses_on_Market_Processed$`City`)),
            selected = unique(na.omit(Houses_on_Market_Processed$`City`)),
            options = list(
                `actions-box` = TRUE), 
                multiple = TRUE
            ),
        
        pickerInput(
            inputId = "bedbuttonsimilar",
            label = "Choose Number of Bedrooms: ", 
            choices = sort(unique(na.omit(Houses_on_Market_Processed$`Total Bedrooms`)),decreasing=FALSE),
            selected = sort(unique(na.omit(Houses_on_Market_Processed$`Total Bedrooms`)),decreasing=FALSE),
            options = list(
                `actions-box` = TRUE), 
            multiple = TRUE
        ),
        
        pickerInput(
            inputId = "book_section",
            label = "Choose House Type: ", 
            choices = unique(Houses_on_Market_Processed$`Book Section`),
            selected = unique(Houses_on_Market_Processed$`Book Section`),
            options = list(
                `actions-box` = TRUE), 
            multiple = TRUE
        ),
        leafletOutput("map")
            )     
        )
    )
)
