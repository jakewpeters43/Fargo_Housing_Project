#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(rsconnect)
library(leaflet)
library(sf)
library(shiny)
library(htmltools)
library(tidyverse)
# Define server logic required to plot house types

FM_Market_Clean <- read_csv("../../Data/FM_Market_Clean.csv")

shinyServer(function(input, output) {
  selected <- reactive({
    input$bedbuttonsimilar
    input$book_section
    input$city
  
    FM_Market_Clean %>% filter(`Total Bedrooms` %in% input$bedbuttonsimilar) %>%
      filter(`Book Section` %in% input$book_section) %>%
      filter(`City` %in% input$city)
  }) 

  output$map <- renderLeaflet({
    map1 <- leaflet(FM_Market_Clean, options=leafletOptions(preferCanvas=TRUE)) %>% addTiles() %>% fitBounds(~min(`Geo Lon`), ~min(`Geo Lat`), ~max(`Geo Lon`), ~max(`Geo Lat`))
  })

  observe({
    leafletProxy("map", data=FM_Market_Clean) %>% clearMarkers() %>% addCircleMarkers(
      data=st_as_sf(selected(), coords=c("Geo Lon", "Geo Lat")),
      radius=1,
      label=lapply(paste0(
        "<div style=text-align:center><img src=",selected()$`Photo URL`,"><br>",
        "List Price: $",selected()$`List Price`,"<br>",
        selected()$`Book Section`,"<br>",
        "Our Estimate: $",round(selected()$`Listing Adjustment Prediction`,-2),"<br>",
        selected()$`Total SqFt.`," sq. ft. / ",selected()$`Total Bedrooms`," Bed / ",selected()$`Total Bathrooms`," Bath</div>"),HTML)
    )
  })
})
