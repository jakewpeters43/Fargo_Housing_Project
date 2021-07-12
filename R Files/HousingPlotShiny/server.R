#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(leaflet)
library(leafgl)
library(sf)
library(shiny)
library(htmltools)
# Define server logic required to plot house types

shinyServer(function(input, output) {
  selected <- reactive({
    input$bedbuttonsimilar
    input$book_section
    input$city
  
    FM_Housing_Clean %>% filter(`Total Bedrooms` %in% input$bedbuttonsimilar) %>%
      filter(`Book Section` %in% input$book_section) %>%
      filter(`City` %in% input$city)
  }) 

  output$map <- renderLeaflet({
    map1 <- leaflet(FM_Housing_Clean, options=leafletOptions(preferCanvas=TRUE)) %>% addTiles() %>% fitBounds(~min(`Geo Lon`), ~min(`Geo Lat`), ~max(`Geo Lon`), ~max(`Geo Lat`))
  })
  
  #current <- FM_Housing_Clean %>% filter(FALSE)

  observe({
    #new <- selected()
    #toAdd <- setdiff(new, current)
    #toRemove <- setdiff(current, new)
    #current <- new
    leafletProxy("map", data=FM_Housing_Clean) %>% clearGlLayers() %>% addGlPoints(
      data=st_as_sf(selected(), coords=c("Geo Lon", "Geo Lat")),
      radius=10,
      popup=paste0("<div style=text-align:center><img src=",selected()$`Photo URL`,"><br>Sales Price: $",selected()$`Sold Price`,"<br>Sales Date: ",selected()$`Sold Date` ,"<br>Address: ",selected()$`Street Address`,"</div>")
    )
  })
})
