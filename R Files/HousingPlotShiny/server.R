#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
#remotes::install_github("rstudio/reactlog")
#reactlog_enable()
library(shiny)
library(plotly)
library(ggplot2)
library(reactlog)
library(memoise)
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
   
    # bedroom_button <- reactive({
    #     df <- FM_Housing_Clean %>% filter(`Total Bedrooms` %in% input$bedbutton)
    # }) #%>%
       # bindCache(input$bedbutton)
    
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
    
output$geom_filters <- renderPlotly({
    
    ggplot(bedroom_button(),aes(x=`Geo Lon`,y=`Geo Lat`, color = as.factor(`Census Tract`),label = `Sold Price`)) + #, aes(text=paste("Sold Price=",`Sold Price`))) + 
        geom_point(mapping = , show.legend = FALSE) +
        xlim(-96.925,-96.72) + ylim(46.76,46.935)
    
 }) #%>%
#     bindCache()

similarHouses_finder <- reactive({
    
    req(input$bedbuttonsimilar)
    req(input$book_section)
    req(input$city)
    
  similar_df <- FM_Housing_Clean %>% filter(`Total Bedrooms` %in% input$bedbuttonsimilar) %>%
                                     filter(`Book Section` %in% input$book_section) %>%
                                     filter(`City` %in% input$city)
 
}) #%>%
   # bindCache(input$bedbuttonsimilar,input$book_section, input$city)

output$scatterplotFinder <- renderPlotly({
    input$bedbuttonsimilar
    input$type
    input$city
    
    ggplot(similarHouses_finder(),aes(x=`Geo Lon`,y=`Geo Lat`, color = as.factor(`Census Tract`),label = `Sold Price`)) + #, aes(text=paste("Sold Price=",`Sold Price`))) + 
        geom_point(mapping = , show.legend = FALSE) +
        xlim(-96.925,-96.72) + ylim(46.76,46.935)

})# %>%
   # bindCache(input$bedbuttonsimilar, input$type,input$city,similarHouses_finder())


})
#shiny::reactlogShow()
