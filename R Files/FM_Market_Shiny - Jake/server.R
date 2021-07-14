#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(leaflet)
library(shiny)
library(scales)
library(tidyverse)
# Define server logic required to plot house types

shinyServer(function(input, output) {
  selected <- reactive({
    input$city
    input$list_price
    input$book_section
    input$sq_ft
    input$bathrooms
    input$bedrooms
    #input$year_built
    
    similar_df <- FM_Market_Clean %>%
      filter(`City` %in% input$city) %>%
      
      filter(if(input$list_price[[1]]>100000) `List Price`>=input$list_price[[1]] else TRUE) %>%
      filter(if(input$list_price[[2]]<1500000) `List Price`<=input$list_price[[2]] else TRUE) %>%
      
      filter(`Book Section` %in% input$book_section) %>%
      
      filter(if(input$bedrooms[[1]]>0) `Total Bedrooms`>=input$bedrooms[[1]] else TRUE) %>%
      filter(if(input$bedrooms[[2]]<10) `Total Bedrooms`<=input$bedrooms[[2]] else TRUE) %>%
      
      filter(if(input$bathrooms[[1]]>0) `Total Bathrooms`>=input$bathrooms[[1]] else TRUE) %>%
      filter(if(input$bathrooms[[2]]<10) `Total Bathrooms`<=input$bathrooms[[2]] else TRUE) %>%
      
      filter(if(input$sq_ft[[1]]>750) `Total SqFt.`>=input$sq_ft[[1]] else TRUE) %>%
      filter(if(input$sq_ft[[2]]<5000) `Total SqFt.`<=input$sq_ft[[2]] else TRUE) 
  })

  output$map <- renderLeaflet({
    map1 <- leaflet(FM_Market_Clean, options=leafletOptions(preferCanvas=TRUE)) %>% addTiles() %>% fitBounds(~min(`Geo Lon`), ~min(`Geo Lat`), ~max(`Geo Lon`), ~max(`Geo Lat`))
  })

  observe({
    leafletProxy("map", data=FM_Market_Clean) %>% clearMarkers() %>% addCircleMarkers(
      lng=selected()$`Geo Lon`, 
      lat=selected()$`Geo Lat`,
      radius=1,
      label=lapply(paste0(
        "<img src=",selected()$`Photo URL`,"><br>",
        "List Price: <b>$",comma(selected()$`List Price`, 100),"</b><br>",
        "Our Estimate: <b>$",comma(selected()$`Adjustment Prediction`, 100),"</b><br>",
        selected()$`Book Section`," - ",selected()$`Style`,"<br>",
        selected()$`Total SqFt.`," sq. ft. / ",selected()$`Total Bedrooms`," Bed / ",selected()$`Total Bathrooms`," Bath"),HTML),
      labelOptions=labelOptions(style=list(
        "text-align"="center",
        "font-size"="15px"
      ))
    )
  })
})
