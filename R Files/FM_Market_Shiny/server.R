shinyServer(function(input, output, session) {
  
  selected <- reactive({
    input$city
    input$book_section
    input$style
    input$foundation
    input$exterior
    input$roof
    input$list_price
    input$sq_ft
    input$bathrooms
    input$bedrooms
    input$year_built
    
    
    FM_Market_Clean %>%
      filter(`City` %in% input$city) %>%
      filter(`Book Section` %in% input$book_section) %>%
      filter(`Style` %in% input$style) %>%
      filter(`Foundation` %in% input$foundation) %>%
      filter(`Exterior` %in% input$exterior) %>%
      filter(`Roof` %in% input$roof) %>%
      
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
    leafletProxy("map", data=FM_Market_Clean) %>% clearMarkers() %>% clearControls() %>% addCircleMarkers(
      lng=selected()$`Geo Lon`, 
      lat=selected()$`Geo Lat`,
      radius=5,
      stroke=FALSE,
      fillOpacity = 0.5,
      layerId=selected()$`Index`,
      group="selected",
      label=lapply(paste0(
        "<img src=",selected()$`Photo URL`,"><br>",
        "List Price: <b>",dollar(selected()$`List Price`, 100),"</b><br>",
        "Our Estimate: <b>",dollar(selected()$`Adjustment Prediction`, 100),"</b><br>",
        selected()$`Book Section`," - ",selected()$`Style`,"<br>",
        selected()$`Total SqFt.`," sq. ft. / ",selected()$`Total Bedrooms`," Bed / ",selected()$`Total Bathrooms`," Bath"), HTML),
      labelOptions=labelOptions(style=list(
        "text-align"="center",
        "font-size"="15px"
      ))
    ) %>%
      addControl(HTML(paste0(
        "<div style=font-size:20px;line-height:1.5>Houses selected: <b>",nrow(selected()),"</b><br>",
        "Average price: <b>",dollar(mean(selected()$`List Price`), 100),"</b></div>")),
        position = "bottomleft")
  })
  
  observeEvent(input$reset, {
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
      #choices = c("1 Story", "1 1/2 Story"="1&frac12 Story", "2 Story", "3 Story", "Bi Level", "3 Level", "4 Level"),
      choices = unique(FM_Market_Clean$`Style`),
      selected = unique(FM_Market_Clean$`Style`),
      options = list(`actions-box` = TRUE)
    )
    
    updatePickerInput(
      session = session,
      inputId = "foundation",
      label = "Foundation type:",
      choices = unique(FM_Market_Clean$`Foundation`),
      selected = unique(FM_Market_Clean$`Foundation`),
      options = list(`actions-box` = TRUE)
    )
    
    updatePickerInput(
      session = session,
      inputId = "exterior",
      label = "Exterior material:",
      choices = unique(FM_Market_Clean$`Exterior`),
      selected = unique(FM_Market_Clean$`Exterior`),
      options = list(`actions-box` = TRUE)
    )
    
    updatePickerInput(
      session = session,
      inputId = "roof",
      label = "Roof material:",
      choices = unique(FM_Market_Clean$`Roof`),
      selected = unique(FM_Market_Clean$`Roof`),
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
  
  observeEvent(input$map_marker_click, {
    clicked <- selected()[selected()$`Index`==input$map_marker_click$id,]
    showModal(modalDialog(
      HTML(paste0(
        "<div style=font-size:20px;text-align:center;><img src=",clicked$`Photo URL`," style=width:100%;height:100%;><br>",
        "List Price: <b>",dollar(clicked$`List Price`, 100),"</b><br>",
        "Our Estimate: <b>",dollar(clicked$`Adjustment Prediction`, 100),"</b><br>",
        clicked$`Book Section`," - ",clicked$`Style`,"<br>",
        clicked$`Total SqFt.`," sq. ft. / ",clicked$`Total Bedrooms`," Bed / ",clicked$`Total Bathrooms`," Bath</div>"
      )),
      easyClose=TRUE,
      footer=modalButton("Close")
    ))
  })
  
  output$result <- eventReactive(input$submit,{
    Predicted_DF$`City` <- input$city1
    Predicted_DF$`Log SqFt`<- log(input$sq_ft1)
    Predicted_DF$`Total Bedrooms` <- input$bedrooms1
    Predicted_DF$`Total Bathrooms` <- input$bathrooms1
    Predicted_DF$`Year Built` <- input$yearbuilt1
    Predicted_DF$`Garage Stalls` <- input$garagestalls1
    Predicted_DF$`Has Air Conditioning` <- input$AC1
    Predicted_DF$`New Construction` <- input$newconstruction1
    Predicted_DF$`Kitchen Island` <- input$kitchenisland1
    Predicted_DF$`Patio` <- input$patio1
    Predicted_DF$`Has Deck` <- input$deck1
    Predicted_DF$`Has Fence` <- input$fence1
    Predicted_DF$`Sprinkler System` <- input$sprinklersystem1
    Predicted_DF$`Gazebo` <- input$gazebo1
    Predicted_DF$`Pool` <- input$pool1
    Predicted_DF$`Pantry` <- input$pantry1
    Predicted_DF$`Walk-in Closet` <- input$walkincloset1
    Predicted_DF$`Private Bath` <- input$privatebath1
    Predicted_DF$`Spa/Hot Tub` <- input$spahottub1
    Predicted_DF$`Style` <- input$style1
    Predicted_DF$`Roof` <- input$roof1
    Predicted_DF$`Water Heater` <- input$waterheater1
    Predicted_DF$`Foundation` <- input$foundation1
    Predicted_DF$`Book Section` <- input$booksection1
    Predicted_DF$`Exterior` <- input$exterior1
    
    toString(dollar(exp(predict(hedonicModel, newdata=Predicted_DF, allow.new.levels=TRUE)), 100))
  })
})