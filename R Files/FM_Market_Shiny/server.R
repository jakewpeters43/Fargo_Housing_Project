library(leaflet)
library(shiny)
library(scales)
library(tidyverse)
library(raster)

shinyServer(function(input, output) {
  selected <- reactive({
    input$city
    input$book_section
    input$style
    input$list_price
    input$sq_ft
    input$bathrooms
    input$bedrooms
    
    similar_df <- FM_Market_Clean %>%
      filter(`City` %in% input$city) %>%
      filter(`Book Section` %in% input$book_section) %>%
      filter(`Style` %in% input$style) %>%
      
      filter(if(input$list_price[[1]]>100000) `List Price`>=input$list_price[[1]] else TRUE) %>%
      filter(if(input$list_price[[2]]<1600000) `List Price`<=input$list_price[[2]] else TRUE) %>%
      
      filter(if(input$bedrooms[[1]]>1) `Total Bedrooms`>=input$bedrooms[[1]] else TRUE) %>%
      filter(if(input$bedrooms[[2]]<8) `Total Bedrooms`<=input$bedrooms[[2]] else TRUE) %>%
      
      filter(if(input$bathrooms[[1]]>1) `Total Bathrooms`>=input$bathrooms[[1]] else TRUE) %>%
      filter(if(input$bathrooms[[2]]<8) `Total Bathrooms`<=input$bathrooms[[2]] else TRUE) %>%
      
      filter(if(input$sq_ft[[1]]>1000) `Total SqFt.`>=input$sq_ft[[1]] else TRUE) %>%
      filter(if(input$sq_ft[[2]]<6000) `Total SqFt.`<=input$sq_ft[[2]] else TRUE) 
  })

  output$map <- renderLeaflet({
    map1 <- leaflet(data=FM_Market_Clean, options=leafletOptions(preferCanvas=TRUE)) %>%
      addTiles() %>%
      fitBounds(minlon, minlat, maxlon, maxlat) %>%
      addEasyButton(easyButton(
        icon = "fa-crosshairs",
        title="Reset zoom",
        onClick = JS(paste0("function(btn, map){ map.fitBounds([[",minlat,",",minlon,"],[",maxlat,",",maxlon,"]]);}"))
      ))
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