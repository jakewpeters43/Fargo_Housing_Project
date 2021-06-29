#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(ggplot2)
# Define server logic required to plot house types
shinyServer(function(input, output) {
    
    observeEvent(input$toggleSidebar, {
        shinyjs::toggle(id="Sidebar")
    })
    
    
    output$result <- renderText({
        paste("You chose", input$type)
    })
    chosendata <- reactive({
        req(input$type)
        
        df <- FM_Housing_Clean %>% filter(`Book Section` %in% input$type)
        
    }) %>%
        bindCache(input$type)
    
    pointdata <- reactive({
        req(input$bedrooms)
        df <- FM_Housing_Clean %>% filter(`Total Bedrooms` %in% input$bedrooms) %>% 
           group_by(median(`Sold Price`),`City`) %>% summarize(median_Sold_Price =median(`Sold Price`))
    }) %>%
        bindCache(input$bedrooms)
    geom_price <- reactive({
        req(input$minprice < input$maxprice)
        df <- FM_Housing_Clean %>% filter(`Sold Price`>=input$minprice & `Sold Price`<=input$maxprice) 
         
    }) %>%
        bindCache(input$minprice, input$maxprice)
   
    
    output$geom_bar <- renderPlot({

        # generate book section type from input$section from ui.R
       # type    <- FM_Housing_Clean[`Book Section`]
       # section <- seq(min(bins), max(bins), length.out = input$section + 1)

        # draw the bar with the specified number of bins
        ggplot(chosendata()) + geom_bar(mapping = aes(x=`Book Section`))

    }) %>%
        bindCache(chosendata())
    
    output$geom_point <- renderPlot({
        
        ggplot(pointdata()) + geom_point(mapping = aes(y = median_Sold_Price, x= `City`))
    }) %>%
        bindCache(pointdata())
    
    output$geom_price <- renderPlotly({
        
        ggplot(geom_price(),aes(x=`Geo Lon`,y=`Geo Lat`, color = as.factor(`Census Tract`),label = `Sold Price`)) + #, aes(text=paste("Sold Price=",`Sold Price`))) + 
            geom_point(mapping = , show.legend = FALSE) +
            xlim(-96.925,-96.72) + ylim(46.76,46.935) 
        #ggplotly(p)
    }) %>%
        bindCache(geom_price())

   # df <- data.frame(x=c(1,2,3,4,5), y=c(6,7,8,9,10), z=c('a','b','c','d','e'))
    
    
    # Define the content and format of the tooltip in the "text" aesthetic
    # p <- ggplot(df, aes(x=x, y=y, 
    #                     text=paste("X=",x,"<br>Y=",y,"<br>Z=",z))) + 
    #     geom_point()
    # 
    # 
    # p <- ggplotly(p, tooltip="text")
    # print(p)
    
    
    output$info <- renderText({
        xy_str <- function(e) {
            if(is.null(e)) return("NULL\n")
            paste0("x=", round(e$x, 1), "y=", round(e$y, 1), "\n")
        }
        xy_range_str <- function(e) {
            if(is.null(e)) return("NULL\n")
            paste0("xmin=", round(e$xmin, 1), " xmax=", round(e$xmax, 1), 
                   " ymin=", round(e$ymin, 1), " ymax=", round(e$ymax, 1))
        }
        
        paste0(
            "hover: ", xy_str(input$plot_hover)
        )
    })
    
    
    
    
})
