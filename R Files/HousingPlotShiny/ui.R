#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


# rsconnect::deployApp('C:\\Users\\13204\\Documents\\GitHub\\FM-Housing\\R Files\\HousingPlotShiny')
library(rsconnect)
library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    
    # Application title
    titlePanel("Book Section"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            # Select type of trend to plot
            selectInput(inputId = "type", label = strong("Choose Book Section"),
                        choices = unique(FM_Housing_Clean$`Book Section`),
                        selected = "Single Family Residence")
        ),
       # sidebarPanel(
            checkboxGroupInput(inputId = "bedrooms", label = strong("Choose # Bedrooms"),
                               choices = unique(FM_Housing_Clean$`Total Bedrooms`),
                               selected = "3"
                               )
        ),
        

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("geom_bar"),
            textOutput("result"),
            plotOutput("geom_point")
        )
    )
)#)
