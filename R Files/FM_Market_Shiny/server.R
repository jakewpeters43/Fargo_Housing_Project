#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(leaflet)
library(sf)
library(shiny)
library(htmltools)
# Define server logic required to plot house types

shinyServer(function(input, output) {
  selected <- reactive({
    input$bedbuttonsimilar
    input$book_section
    input$city
  
    Houses_on_Market_Processed %>% filter(`Total Bedrooms` %in% input$bedbuttonsimilar) %>%
      filter(`Book Section` %in% input$book_section) %>%
      filter(`City` %in% input$city)
  }) 

  output$map <- renderLeaflet({
    map1 <- leaflet(Houses_on_Market_Processed, options=leafletOptions(preferCanvas=TRUE)) %>% addTiles() %>% fitBounds(~min(`Geo Lon`), ~min(`Geo Lat`), ~max(`Geo Lon`), ~max(`Geo Lat`))
  })

  observe({
    leafletProxy("map", data=Houses_on_Market_Processed) %>% clearMarkers() %>% addCircleMarkers(
      data=st_as_sf(selected(), coords=c("Geo Lon", "Geo Lat")),
      radius=1,
      label=lapply(paste0(
        "<div style=text-align:center><img src=",selected()$`Photo URL`,"><br>",
        "List Price: $",selected()$`List Price`,"<br>",
        "Our Estimate: $",round(selected()$`Prediction from Listing`,-2),"<br>",
        selected()$`Total SqFt.`," sq. ft. / ",selected()$`Total Bedrooms`," Bed / ",selected()$`Total Bathrooms`," Bath</div>"),HTML)
    )
  })
})
