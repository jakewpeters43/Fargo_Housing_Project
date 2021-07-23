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
  # selected <- reactive({
  #   input$city
  #   input$list_price
  #   input$book_section
  #   input$sq_ft
  #   input$bathrooms
  #   input$bedrooms
  #   #input$year_built
  #   
  #   similar_df <- FM_Market_Clean %>%
  #     filter(`City` %in% input$city) %>%
  #     
  #     filter(if(input$list_price[[1]]>100000) `List Price`>=input$list_price[[1]] else TRUE) %>%
  #     filter(if(input$list_price[[2]]<1500000) `List Price`<=input$list_price[[2]] else TRUE) %>%
  #     
  #     filter(`Book Section` %in% input$book_section) %>%
  #     
  #     filter(if(input$bedrooms[[1]]>0) `Total Bedrooms`>=input$bedrooms[[1]] else TRUE) %>%
  #     filter(if(input$bedrooms[[2]]<10) `Total Bedrooms`<=input$bedrooms[[2]] else TRUE) %>%
  #     
  #     filter(if(input$bathrooms[[1]]>0) `Total Bathrooms`>=input$bathrooms[[1]] else TRUE) %>%
  #     filter(if(input$bathrooms[[2]]<10) `Total Bathrooms`<=input$bathrooms[[2]] else TRUE) %>%
  #     
  #     filter(if(input$sq_ft[[1]]>750) `Total SqFt.`>=input$sq_ft[[1]] else TRUE) %>%
  #     filter(if(input$sq_ft[[2]]<5000) `Total SqFt.`<=input$sq_ft[[2]] else TRUE) 
  # })
  # 
  # output$map <- renderLeaflet({
  #   map1 <- leaflet(FM_Market_Clean, options=leafletOptions(preferCanvas=TRUE)) %>% addTiles() %>% fitBounds(~min(`Geo Lon`), ~min(`Geo Lat`), ~max(`Geo Lon`), ~max(`Geo Lat`))
  # })
  # 
  # observe({
  #   leafletProxy("map", data=FM_Market_Clean) %>% clearMarkers() %>% addCircleMarkers(
  #     lng=selected()$`Geo Lon`, 
  #     lat=selected()$`Geo Lat`,
  #     radius=3.5,
  #     label=lapply(paste0(
  #       "<img src=",selected()$`Photo URL`,"><br>",
  #       "List Price: <b>$",comma(selected()$`List Price`, 100),"</b><br>",
  #       "Our Estimate: <b>$",comma(selected()$`Adjustment Prediction`, 100),"</b><br>",
  #       selected()$`Book Section`," - ",selected()$`Style`,"<br>",
  #       selected()$`Total SqFt.`," sq. ft. | ",selected()$`Total Bedrooms`," Bed | ",selected()$`Total Bathrooms`," Bath"),HTML),
  #     labelOptions=labelOptions(style=list(
  #       "text-align"="center",
  #       "font-size"="15px"
  #     ))
  #   )
  # })
  

  
  formData <- reactive({
    input$city1
    input$sq_ft1
    input$bathrooms1
    input$bedrooms1
    input$yearbuilt1
   
    
    newdata <- FM_Housing_Clean %>% filter(FALSE) 
    newdata[1,] <- NA
    data_na <- newdata[1,] 
    
    
    data_na$`City` <- input$city1
    data_na$`Log SqFt`<- log(input$sq_ft1)
    data_na$`Total Bedrooms` <- input$bedrooms1
    data_na$`Total Bathrooms` <- input$bathrooms1
    data_na$`Year Built` <- input$yearbuilt1
    data_na$`Garage Stalls` <- input$garagestalls1
    data_na$`Has Air Conditioning` <- input$AC1
    data_na$`New Construction` <- input$newconstruction1
    data_na$`Kitchen Island` <- input$kitchenisland1
    data_na$`Patio` <- input$patio1
    data_na$`Has Deck` <- input$deck1
    data_na$`Has Fence` <- input$fence1
    data_na$`Sprinkler System` <- input$sprinklersystem1
    data_na$`Gazebo` <- input$gazebo1
    data_na$`Pool` <- input$pool1
    data_na$`Pantry` <- input$pantry1
    data_na$`Walk-in Closet` <- input$walkincloset1
    data_na$`Private Bath` <- input$privatebath1
    data_na$`Spa/Hot Tub` <- input$spahottub1
    data_na$`Style` <- input$style1
    data_na$`Roof` <- input$roof1
    data_na$`Water Heater` <- input$waterheater1
    data_na$`Foundation` <- input$foundation1
    data_na$`Book Section` <- input$booksection1
    data_na$`Exterior` <- input$exterior1
    data_na
  })

 output$result <- eventReactive(input$submit,{
    
   toString(exp(predict(hedonicModel, newdata=formData(), allow.new.levels=TRUE)))
   

  })
 
  
})