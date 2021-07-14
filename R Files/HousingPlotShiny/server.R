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
library(rgeos) 
library(sp)
library(leaflet)
library(shiny)
library(htmltools)
# Define server logic required to plot house types
shinyServer(function(input, output) {
  

leaflet_finder <- FM_Market_Clean %>% rename("elat"="Geo Lat" , "elon"="Geo Lon")

similarHouses_finder <- reactive({
  
    req(input$bed_slider)
    req(input$book_section)
    req(input$price_slider)
    req(input$bath_slider)
    req(input$sq_slider)
   # req(input$year_slider)
  
  similar_df <- leaflet_finder %>% 
    filter(if(input$bed_slider[[1]]>1) `Total Bedrooms`>=input$bed_slider[[1]] else TRUE) %>%
    filter(if(input$bed_slider[[2]]<7) `Total Bedrooms`<=input$bed_slider[[2]] else TRUE) %>%
    
    filter(if(input$bath_slider[[1]]>1) `Total Bathrooms`>=input$bath_slider[[1]] else TRUE) %>%
    filter(if(input$bath_slider[[2]]<7) `Total Bathrooms`<=input$bath_slider[[2]] else TRUE) %>%
    
    filter(`Book Section` %in% input$book_section) %>%
    
    filter(`City` %in% input$city) %>%
    
    filter(if(input$price_slider[[1]]>40000) `Sold Price`>=input$price_slider[[1]] else TRUE) %>%
    filter(if(input$price_slider[[2]]<700000) `Sold Price`<=input$price_slider[[2]] else TRUE) %>%
  
    filter(if(input$sq_slider[[1]]>100) `Total SqFt.`>=input$sq_slider[[1]] else TRUE) %>%
    filter(if(input$sq_slider[[2]]<4000) `Total SqFt.`<=input$sq_slider[[2]] else TRUE)# %>% 
    
   # filter(if(input$sq_slider[[1]]>1600) `Year Built`>=input$year_slider[[1]] else TRUE) %>%
   # filter(if(input$sq_slider[[2]]<2021) `Year Built`<=input$year_slider[[2]] else TRUE) 
})            

output$map2 <- renderLeaflet({

  leaflet(leaflet_finder, options = leafletOptions(preferCanvas = TRUE)) %>% addTiles() %>%
    fitBounds(~min(`elon`), ~min(`elat`),~max(`elon`), ~max(`elat`))
}) 


observe({
  leafletProxy("map2", data = similarHouses_finder()) %>%
    clearMarkers() %>%
    clearMarkerClusters() %>%
    addCircleMarkers(lng = similarHouses_finder()$`elon`, lat = similarHouses_finder()$`elat`,
                      clusterOptions = markerClusterOptions(maxClusterRadius = 100, disableClusteringAtZoom = 15, spiderfyOnMaxZoom = FALSE), radius = 5, 
                      label = lapply(paste0("<img src=",similarHouses_finder()$`Photo URL`,">", 
                                            "<br>", "$ ",similarHouses_finder()$`Sold Price` , "<br>"
                                            ,similarHouses_finder()$`Sold Date` , "<br>",similarHouses_finder()$`Street Address`, "<br>"), HTML), 
                      labelOptions = labelOptions(style=list("text-align" ="center"))
                      
    )
})


})
#shiny::reactlogShow()
