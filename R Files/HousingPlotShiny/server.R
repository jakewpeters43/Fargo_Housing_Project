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
library(DT)
library(wordcloud2)
# Define server logic required to plot house types
shinyServer(function(input, output) {
  
FM_Housing_Clean[54773,164] <- "339 12 Avenue E West Fargo ND 58078"
FM_Housing_Clean[54767,164] <- "220 10 Avenue E West Fargo ND 58078"
leaflet_finder <- FM_Housing_Clean %>% rename("elat"="Geo Lat" , "elon"="Geo Lon")

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
# word counts (excluding stop words) for word clouds
word_counts <- reactive({ 
  req(input$disc)
  FM_Housing_Clean %>% 
    filter(disc_number %in% input$disc_cloud) %>%
    select(word) %>% 
    anti_join(stop_words, by = "word") %>%
    #filter(word != "love") %>% 
    count(word, sort = TRUE) 
}) 

# Word Clouds
output$wordcloud <- renderWordcloud2({
  wordcloud2(word_counts(), size = 1.6, fontFamily = "Courier",
             color=rep_len(pal[2:4], nrow(word_counts())), backgroundColor = "black")
})

# Word search table
output$counttable = DT::renderDataTable({
  DT::datatable(word_counts(), options = list(lengthMenu = c(10, 20, 50), pageLength = 10),
                rownames = FALSE, colnames = c("Word", "Count"), class = 'compact',
                caption = 'Common words (e.g. the, is, at) are excluded')
})


})
#shiny::reactlogShow()
