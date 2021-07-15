library(leaflet)
library(shiny)
library(scales)
library(tidyverse)
library(raster)

shinyServer(function(input, output, session) {
  
  selected <- reactive({
    input$city
    input$book_section
    input$style
    input$list_price
    input$sq_ft
    input$bathrooms
    input$bedrooms
    input$year_built
    
    similar_df <- FM_Market_Clean %>%
      filter(`City` %in% input$city) %>%
      filter(`Book Section` %in% input$book_section) %>%
      filter(`Style` %in% input$style) %>%
      
      filter(if(input$list_price[[1]]>min_listprice) `List Price`>=input$list_price[[1]] else TRUE) %>%
      filter(if(input$list_price[[2]]<max_listprice) `List Price`<=input$list_price[[2]] else TRUE) %>%
      
      filter(if(input$bedrooms[[1]]>min_bedrooms) `Total Bedrooms`>=input$bedrooms[[1]] else TRUE) %>%
      filter(if(input$bedrooms[[2]]<max_bedrooms) `Total Bedrooms`<=input$bedrooms[[2]] else TRUE) %>%
      
      filter(if(input$bathrooms[[1]]>min_bathrooms) `Total Bathrooms`>=input$bathrooms[[1]] else TRUE) %>%
      filter(if(input$bathrooms[[2]]<max_bathrooms) `Total Bathrooms`<=input$bathrooms[[2]] else TRUE) %>%
      
      filter(if(input$sq_ft[[1]]>min_sqft) `Total SqFt.`>=input$sq_ft[[1]] else TRUE) %>%
      filter(if(input$sq_ft[[2]]<max_sqft) `Total SqFt.`<=input$sq_ft[[2]] else TRUE) %>%
      
      filter(if(input$year_built[[1]]>min_yearbuilt) `Year Built`>=input$year_built[[1]] else TRUE) %>%
      filter(if(input$year_built[[2]]<max_yearbuilt) `Year Built`<=input$year_built[[2]] else TRUE)
  })

  output$map <- renderLeaflet({
    map1 <- leaflet(data=FM_Market_Clean, options=leafletOptions(preferCanvas=TRUE)) %>%
      addTiles() %>%
      fitBounds(min_lon, min_lat, max_lon, max_lat) %>%
      addEasyButton(easyButton(
        icon = "fa-crosshairs",
        title="Recenter map",
        onClick = JS(
          "function(btn, map) {map.fitBounds(map.layerManager.getLayerGroup('selected').getBounds(), {padding: [1,1]});}"
        ) 
      ))
  })

  observe({
    leafletProxy("map", data=FM_Market_Clean) %>% clearMarkers() %>% addCircleMarkers(
      lng=selected()$`Geo Lon`, 
      lat=selected()$`Geo Lat`,
      radius=2,
      group="selected",
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
  
  observeEvent(input$reset,{
    updatePickerInput(
      session = session,
      inputId = "city",
      label = "City:", 
      choices = unique(na.omit(FM_Market_Clean$`City`)),
      selected = unique(na.omit(FM_Market_Clean$`City`)),
      options = list(`actions-box` = TRUE)
    )
      
    updatePickerInput(
      session = session,
      inputId = "book_section",
      label = "House Type:", 
      choices = unique(FM_Market_Clean$`Book Section`),
      selected = unique(FM_Market_Clean$`Book Section`),
      options = list(`actions-box` = TRUE)
    )
      
    updatePickerInput(
      session = session,
      inputId = "style",
      label = "House style:",
      choices = c("1 Story", "1 1/2 Story"="1&frac12 Story", "2 Story", "3 Story", "Bi Level", "3 Level", "4 Level"),
      selected = unique(FM_Market_Clean$`Style`),
      options = list(`actions-box` = TRUE)
    )
      
    updateSliderInput(
      session = session,
      inputId = "list_price",
      label = "Price Range:",
      min = min_listprice,
      max = max_listprice,
      value = c(min_listprice, max_listprice),
      step=5000
    )
      
    updateSliderInput(
      session = session,
      inputId = "sq_ft",
      label = "Square Footage:",
      min = min_sqft,
      max = max_sqft,
      value = c(min_sqft, max_sqft),
      step=50
    )
      
    updateSliderInput(
      session = session,
      inputId = "bedrooms",
      label = "Bedrooms:", 
      min = min_bedrooms,
      max = max_bedrooms,
      value = c(min_bedrooms, max_bedrooms)
    )
      
    updateSliderInput(
      session = session,
      inputId = "bathrooms",
      label = "Bathrooms:",
      min = min_bathrooms,
      max = max_bathrooms,
      value = c(min_bathrooms, max_bathrooms),
      step = 0.5
    )
      
    updateSliderInput(
      session = session,
      inputId = "year_built",
      label = "Year Built:",
      min = min_yearbuilt,
      max = max_yearbuilt,
      value = c(min_yearbuilt, max_yearbuilt)
    )
      
    leafletProxy("map", data=FM_Market_Clean) %>% fitBounds(min_lon, min_lat, max_lon, max_lat)
  })
})