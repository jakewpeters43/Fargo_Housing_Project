#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to plot townhouses
shinyServer(function(input, output) {

    output$result <- renderText({
        paste("You chose", input$type)
    })
    chosendata <- reactive({
        req(input$type)
        
        df <- FM_Housing_Clean %>% filter(`Book Section` %in% input$type)
        
    })
    pointdata <- reactive({
        req(input$bedrooms)
        df <- FM_Housing_Clean %>% filter(`Total Bedrooms` %in% input$bedrooms) %>% 
           group_by(median(`Sold Price`),`City`) %>% summarize(median_Sold_Price =median(`Sold Price`))
        
    })
    
    output$geom_bar <- renderPlot({

        # generate book section type from input$section from ui.R
       # type    <- FM_Housing_Clean[`Book Section`]
       # section <- seq(min(bins), max(bins), length.out = input$section + 1)

        # draw the bar with the specified number of bins
        ggplot(chosendata()) + geom_bar(mapping = aes(x=`Book Section`))

    })
    
    output$geom_point <- renderPlot({
        
        ggplot(pointdata()) + geom_point(mapping = aes(y = median_Sold_Price, x= `City`))
    })

})
