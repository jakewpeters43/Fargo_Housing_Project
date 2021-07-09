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
library(maptools)
library(leaflet)
library(shiny)
library(htmltools)
# Define server logic required to plot house types
shinyServer(function(input, output) {
    
  FM_Housing_Clean[54767,27] <- "10"
leaflet_finder <- FM_Housing_Clean %>% tail(2500) %>% rename("elat"="Geo Lat" , "elon"="Geo Lon")
similarHouses_finder <- reactive({
  
    req(input$bedbuttonsimilar)
    req(input$book_section)
    req(input$city)
  
  similar_df <- leaflet_finder %>% filter(`Total Bedrooms` %in% input$bedbuttonsimilar) %>%
                                     filter(`Book Section` %in% input$book_section) %>%
                                     filter(`City` %in% input$city)
 
}) 

output$scatterplotFinder <- renderPlot({
    input$bedbuttonsimilar
    input$book_section
    input$city
    
   
     ggplot(similarHouses_finder(),aes(x=`elon`,y=`elat`, color = as.factor(`Census Tract`),label = `Sold Price`)) + #, aes(text=paste("Sold Price=",`Sold Price`))) + 
         geom_point(mapping = , show.legend = FALSE) +
        xlim(-96.925,-96.72) + ylim(46.76,46.935)
    

}) %>%
    bindCache(input$book_section, input$bedbuttonsimilar, input$city)

maptypes <- c("MapQuestOpen.Aerial",
              "Stamen.TerrainBackground",
              "Esri.WorldImagery",
              "OpenStreetMap",
              "Stamen.Watercolor")


#FM_Housing_trunc <- FM_Housing_Clean %>% head(4766)

output$map <- renderLeaflet({
  input$bedbuttonsimilar
  input$book_section
  input$city
  
  map1 <- leaflet() %>%
    addProviderTiles(maptypes[4]) %>%
    addCircleMarkers( lng = similarHouses_finder()$`elon`, lat = similarHouses_finder()$`elat`,
                     clusterOptions = markerClusterOptions(maxClusterRadius = 100, disableClusteringAtZoom = 16, spiderfyOnMaxZoom = FALSE), radius = 5, 
                     label = lapply(paste0("<img src=",similarHouses_finder()$`Photo URL`,">", "<br>", "$ ",similarHouses_finder()$`Sold Price` , "<br>",similarHouses_finder()$`Street Address`, "<br>"), HTML), labelOptions = labelOptions(style=list("text-align" ="center"))
    )
  
  map1
})



#shiny::reactlogShow()
})