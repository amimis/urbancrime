library(shiny)
library(shinydashboard)
library(leaflet)
library(leaflet.extras)
library(rgdal)  # shpfile, join
library(dplyr)
library(stringr)


# read shpfile
#m <- readOGR("shp/mun.shp")

# read csv
#d <- read.csv("csv/data.csv")
#d <- read.csv2("csv/data_v04112022.csv")

# join
#m <- m[order(match(m$Id, d$ID))]

#m <- merge(m, d, by.x='Id', by.y='ID' )
load( "urbancrime_data.RData" )

LabFunct <- function(){
    add_lab <- paste0("<strong>",m$name, "</strong>")
    add_lab <- paste0(add_lab,"<br><strong> Πληθυσμός: </strong>", m$pop)
    add_lab <- paste0(add_lab,"<br><strong> Νοικοκυριά: </strong>", m$nhouse)
    return(add_lab)
}

# classification and color

# χάρτης εγκληματικότητας μετά την κρίση
binsq15aI3 <- c(12.0, 30.0, 45.0, 58.0)
palq15aI3 <- colorBin("YlOrRd", domain = m$q15aI3, bins = binsq15aI3)

# χαρτης εγκληματικότητας  κατά την περίοδο της κρίσης
binsq15bI3 <- c(50.0, 57.3, 67.8, 75.4 )
palq15bI3 <- colorBin("YlOrRd", domain = m$q15bI3, bins = binsq15bI3)


# χάρτης θυματοποίησης μετά την κρίση
binsq17I1 <- c(7.8, 11.5, 18.0, 26.5)
palq17I1 <- colorBin("YlOrRd", domain = m$q17I1, bins = binsq17I1)

# χάρτης θυματοποίησης κατά την περίοδο της κρίσης
binsq18I1 <- c(27.1, 29.6, 34.9, 40.8)
palq18I1 <- colorBin("YlOrRd", domain = m$q18I1, bins = binsq18I1)


# χάρτης ασφάλειας μετά την κρίση
binsq19I12 <- c(47.3, 57.6, 66.1, 93.2)
palq19I12 <- colorBin("YlOrRd", domain = m$q19I12, bins = binsq19I12)

# χάρτης ασφάλειας κατά την περίοδο της κρίσης
binsq22I12 <- c(46.7, 62.2, 68.9, 84.8)
palq22I12 <- colorBin("YlOrRd", domain = m$q22I12, bins = binsq22I12)


# χάρτης ΑΤ μετά την κρίση
binsq25I12 <- c(34.6, 44.2, 50.8, 58.5)
palq25I12 <- colorBin("YlOrRd", domain = m$q25I12, bins = binsq25I12)

# χάρτης ΑΤ κατά την περίοδο της κρίσης
binsq26I12 <- c(22.6, 34.0, 46.0, 58.1)
palq26I12 <- colorBin("YlOrRd", domain = m$q26I12, bins = binsq26I12)

server <- function(input, output) {
    output$mymap15 <- renderLeaflet(
        leaflet(options = leafletOptions(minZoom = 11, maxZoom = 14)) %>%
            addProviderTiles("OpenStreetMap.Mapnik", group = "OpenStreetMap") %>%
            setView(lng = 23.72, lat = 38.00, zoom = 12) %>%
            setMaxBounds( 23.62, 37.95, 23.82, 38.05 ) %>%
            
            addScaleBar(position = "bottomleft", scaleBarOptions(metric = TRUE, imperial = FALSE ,updateWhenIdle = TRUE))%>%
            addEasyButton(easyButton(icon = "fa-globe", title = "Zoom", onClick = JS("function(btn, map){ map.setZoom(12); }"))) %>%
            
            addPolygons(data = m,color = "white", weight = 1, smoothFactor = 0.5, fillOpacity = 1, fillColor = palq15aI3(m$q15aI3), popup=LabFunct(),
                        highlight = highlightOptions(weight = 5,color = "white", fillOpacity = 1, bringToFront = TRUE),
                        group = "μετά την κρίση") %>%
            addLegend(pal = palq15aI3, values = m$q15aI3, position = "bottomright", title = "ΥΠΟΜΝΗΜΑ", opacity = "1", group = "μετά την κρίση")%>%
            
            addPolygons(data = m,color = "white", weight = 1, smoothFactor = 0.5, fillOpacity = 1, fillColor = palq15bI3(m$q15bI3),popup=LabFunct(),
                        highlight = highlightOptions(weight = 5,color = "white",fillOpacity = 1,bringToFront = TRUE),
                        group = "κατά την περίοδο της κρίσης") %>%
            addLegend(pal = palq15bI3, values = m$q15bI3, position = "bottomright", title = "ΥΠΟΜΝΗΜΑ", opacity = "1", group = "κατά την περίοδο της κρίσης")%>%
            
            addLayersControl(baseGroups = c("μετά την κρίση", "κατά την περίοδο της κρίσης"),
                             options = layersControlOptions(collapsed = FALSE))%>%
            addResetMapButton()%>%
            hideGroup(c("μετά την κρίση", "κατά την περίοδο της κρίσης"))%>%
            showGroup("μετά την κρίση")
    )
    
    observeEvent(input$mymap15_groups, {
        mymap15ab <- leafletProxy("mymap15") %>% clearControls()
        
        if (input$mymap15_groups[2] == "μετά την κρίση") {
            mymap15ab <- mymap15ab %>%
                addLegend(pal = palq15aI3, values = m$q15aI3, position = "bottomright", title = "ΥΠΟΜΝΗΜΑ", opacity = "1")
            
        }else{
            mymap15ab <- mymap15ab %>%
                addLegend(pal = palq15bI3, values = m$q15bI3, position = "bottomright", title = "ΥΠΟΜΝΗΜΑ", opacity = "1")
        }
    })
    
    output$mymap1718 <- renderLeaflet(
        leaflet(options = leafletOptions(minZoom = 11, maxZoom = 14)) %>%
            addProviderTiles("OpenStreetMap.Mapnik", group = "OpenStreetMap") %>%
            setView(lng = 23.72, lat = 38.00, zoom = 12) %>%
            setMaxBounds( 23.62, 37.95, 23.82, 38.05 ) %>%
            
            addScaleBar(position = "bottomleft", scaleBarOptions(metric = TRUE, imperial = FALSE ,updateWhenIdle = TRUE))%>%
            addEasyButton(easyButton(icon = "fa-globe", title = "Zoom", onClick = JS("function(btn, map){ map.setZoom(12); }"))) %>%
            
            addPolygons(data = m,color = "white", weight = 1, smoothFactor = 0.5, fillOpacity = 1, fillColor = palq17I1(m$q17I1), popup=LabFunct(),  
                        highlight = highlightOptions(weight = 5,color = "white",fillOpacity = 1,bringToFront = TRUE),
                        group = "μετά την κρίση") %>%
            addLegend(pal = palq17I1, values = m$q17I1, position = "bottomright", title = "ΥΠΟΜΝΗΜΑ", opacity = "1", group = "μετά την κρίση")%>%
            
            addPolygons(data = m,color = "white",weight = 1,smoothFactor = 0.5,fillOpacity = 1,fillColor = palq18I1(m$q18I1), popup=LabFunct(),
                        highlight = highlightOptions(weight = 5,color = "white",fillOpacity = 1,bringToFront = TRUE),
                        group = "κατά την περίοδο της κρίσης") %>%
            addLegend(pal = palq18I1, values = m$q18I1, position = "bottomright", title = "ΥΠΟΜΝΗΜΑ", opacity = "1", group = "κατά την περίοδο της κρίσης")%>%
            
            addLayersControl(baseGroups = c("μετά την κρίση", "κατά την περίοδο της κρίσης"),
                             options = layersControlOptions(collapsed = FALSE))%>%
            addResetMapButton()%>%
            hideGroup("κατά την περίοδο της κρίσης")
    )
    
    observeEvent(input$mymap1718_groups, {
        mymap1718 <- leafletProxy("mymap1718") %>% clearControls()
        
        if (input$mymap1718_groups[2] == "μετά την κρίση") {
            mymap1718 <- mymap1718 %>%
                addLegend(pal = palq17I1, values = m$q17I1, position = "bottomright", title = "ΥΠΟΜΝΗΜΑ", opacity = "1")
            
        }else{
            mymap1718 <- mymap1718 %>%
                addLegend(pal = palq18I1, values = m$q18I1, position = "bottomright", title = "ΥΠΟΜΝΗΜΑ", opacity = "1")
        }
    })
    
    
    output$mymap1922 <- renderLeaflet(
        leaflet(options = leafletOptions(minZoom = 11, maxZoom = 14)) %>%
            addProviderTiles("OpenStreetMap.Mapnik", group = "OpenStreetMap") %>%
            setView(lng = 23.72, lat = 38.00, zoom = 12) %>%
            setMaxBounds( 23.62, 37.95, 23.82, 38.05 ) %>%
            
            addScaleBar(position = "bottomleft", scaleBarOptions(metric = TRUE, imperial = FALSE ,updateWhenIdle = TRUE))%>%
            addEasyButton(easyButton(icon = "fa-globe", title = "Zoom", onClick = JS("function(btn, map){ map.setZoom(12); }"))) %>%
            
            addPolygons(data = m,color = "white",weight = 1,smoothFactor = 0.5,fillOpacity = 1,fillColor = palq19I12(m$q19I12), popup=LabFunct(), 
                        highlight = highlightOptions(weight = 5,color = "white",fillOpacity = 1,bringToFront = TRUE),
                        group = "μετά την κρίση") %>%
            addLegend(pal = palq19I12, values = m$q19I12, position = "bottomright", title = "ΥΠΟΜΝΗΜΑ", opacity = "1", group = "μετά την κρίση")%>%
            
            addPolygons(data = m,color = "white",weight = 1,smoothFactor = 0.5,fillOpacity = 1,fillColor = palq22I12(m$q22I12), popup=LabFunct(),
                        highlight = highlightOptions(weight = 5,color = "white",fillOpacity = 1,bringToFront = TRUE),
                        group = "κατά την περίοδο της κρίσης") %>%
            addLegend(pal = palq22I12, values = m$q22I12, position = "bottomright", title = "ΥΠΟΜΝΗΜΑ", opacity = "1", group = "κατά την περίοδο της κρίσης")%>%
            
            addLayersControl(baseGroups = c("μετά την κρίση", "κατά την περίοδο της κρίσης"),
                             options = layersControlOptions(collapsed = FALSE))%>%
            addResetMapButton()%>%
            hideGroup("κατά την περίοδο της κρίσης")
    )
    
    observeEvent(input$mymap1922_groups, {
        mymap1922 <- leafletProxy("mymap1922") %>% clearControls()
        
        if (input$mymap1922_groups[2] == "μετά την κρίση") {
            mymap1922 <- mymap1922 %>%
                addLegend(pal = palq19I12, values = m$q19I12, position = "bottomright", title = "ΥΠΟΜΝΗΜΑ", opacity = "1")
            
        }else{
            mymap1922 <- mymap1922 %>%
                addLegend(pal = palq22I12, values = m$q22I12, position = "bottomright", title = "ΥΠΟΜΝΗΜΑ", opacity = "1")
        }
    })
    
    output$mymap2526 <- renderLeaflet(
        leaflet(options = leafletOptions(minZoom = 11, maxZoom = 14)) %>%
            addProviderTiles("OpenStreetMap.Mapnik", group = "OpenStreetMap") %>%
            setView(lng = 23.72, lat = 38.00, zoom = 12) %>%
            setMaxBounds( 23.62, 37.95, 23.82, 38.05 ) %>%
            
            addScaleBar(position = "bottomleft", scaleBarOptions(metric = TRUE, imperial = FALSE ,updateWhenIdle = TRUE))%>%
            addEasyButton(easyButton(icon = "fa-globe", title = "Zoom", onClick = JS("function(btn, map){ map.setZoom(12); }"))) %>%
            
            addPolygons(data = m,color = "white",weight = 1,smoothFactor = 0.5,fillOpacity = 1,fillColor = palq25I12(m$q25I12), popup=LabFunct(), 
                        highlight = highlightOptions(weight = 5,color = "white",fillOpacity = 1,bringToFront = TRUE),
                        group = "μετά την κρίση") %>%
            addLegend(pal = palq25I12, values = m$q125I12, position = "bottomright", title = "ΥΠΟΜΝΗΜΑ", opacity = "1", group = "μετά την κρίση")%>%
            
            addPolygons(data = m,color = "white",weight = 1,smoothFactor = 0.5,fillOpacity = 1,fillColor = palq26I12(m$q26I12), popup=LabFunct(),
                        highlight = highlightOptions(weight = 5,color = "white",fillOpacity = 1,bringToFront = TRUE),
                        group = "κατά την περίοδο της κρίσης") %>%
            addLegend(pal = palq26I12, values = m$q26I12, position = "bottomright", title = "ΥΠΟΜΝΗΜΑ", opacity = "1", group = "κατά την περίοδο της κρίσης")%>%
            
            addLayersControl(baseGroups = c("μετά την κρίση", "κατά την περίοδο της κρίσης"),
                             options = layersControlOptions(collapsed = FALSE))%>%
            addResetMapButton()%>%
            hideGroup("κατά την περίοδο της κρίσης")
    )
    
    observeEvent(input$mymap2526_groups, {
        mymap2526 <- leafletProxy("mymap2526") %>% clearControls()
        
        if (input$mymap2526_groups[2] == "μετά την κρίση") {
            mymap2526 <- mymap2526 %>%
                addLegend(pal = palq25I12, values = m$q25I12, position = "bottomright", title = "ΥΠΟΜΝΗΜΑ", opacity = "1")
            
        }else{
            mymap2526 <- mymap2526 %>%
                addLegend(pal = palq26I12, values = m$q26I12, position = "bottomright", title = "ΥΠΟΜΝΗΜΑ", opacity = "1")
        }
    })
    
}














