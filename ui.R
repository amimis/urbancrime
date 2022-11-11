library(shiny)
library(shinydashboard)
library(leaflet)
library(leaflet.extras)
library(rgdal)  # shpfile, join
library(dplyr)
library(stringr)

ui <-dashboardPage(title = "Urban Crime", skin = "blue",
                  dashboardHeader(title = "UrbanCrime", titleWidth = 280),
                  
                  # πλαϊνο menu
                  dashboardSidebar(width = 240, sidebarMenu("ΕΠΙΛΟΓΗ ΧΑΡΤΗ",
                                                            # 1ο menuitem
                                                            menuItem("Εγκληματικότητα", tabName = "m1"),
                                                            # 2o menuitem
                                                            menuItem("Θυματοποίηση", tabName = "m2"),
                                                            # 3o menuitem
                                                            menuItem("Ασφάλεια", tabName = "m3"),
                                                            # 4o menuitem
                                                            menuItem("Αστυνομικό τμήμα", tabName = "m4"),
                                                            div( style="position: absolute; bottom: 5px;",
                                                                 br(),
                                                                 p( a(href='http://www.urbancrime.gr', 
                                                                      img(src="urban_logo.png", alt="Urban Crime Logo", 
                                                                          style="width:150px;height:40px;background-color:white;"))),
                                                                 br(),
                                                                 p(style="font-size: 8px;"," (Αριθμός Έργου: HFRI-FM17-3898)" ),
                                                                 p( a(href='https://www.elidek.gr',
                                                                      img(src="elidek_logo.png", alt="ΕΛΙΔΕΚ Logo", 
                                                                          style="width:150px;height:44px;background-color:white;")))
                                                            )
                  )),
                  dashboardBody(fluidRow(
                      mainPanel(
                          tabsetPanel(type = "tab",
                                      tabPanel("Χάρτης", tabItems(   
                                          # Ενεργοποίηση menuItem
                                          tabItem(tabName = "m1",
                                                  fluidRow( column(width = 11,
                                                                   box(leafletOutput(outputId = "mymap15"),width = "11"),
                                                                   box(width = "11",p(style="font-size: 12px;","Ερωτώμενοι που θεωρούν ότι
                                                                                      αυξήθηκε η εγκληματικότητα στην περιοχή τους (% ποσοστό)."))
                                                                   ))
                                                  ),
                                          tabItem(tabName = "m2",
                                                  fluidRow( column(width = 11,
                                                                   box(leafletOutput(outputId = "mymap1718"),width = "11"),
                                                                   box(width = "11",p(style="font-size: 12px;","Εμπειρία άμεσης θυματoποίησης των ερωτώμενων (% ποσοστό)."))
                                                  ))
                                          ),
                                          tabItem(tabName = "m3",
                                                  fluidRow( column(width = 11,
                                                                   box(leafletOutput(outputId = "mymap1922"),width = "11"),
                                                                   box(width = "11",p(style="font-size: 12px;","Ερωτώμενοι που αισθανονται ασφαλείς 
                                                                                      όταν κυκλοφορούν στην περιοχή κατοικίας τους όταν βραδιάζει (% ποσοστό)."))
                                                                   ))
                                                  ),
                                          tabItem(tabName = "m4",
                                                  fluidRow( column(width = 11,
                                                                   box(leafletOutput(outputId = "mymap2526"),width = "11"),
                                                                   box(width = "11",p(style="font-size: 12px;","Ερωτώμενοι που κρίνουν αποτελεσματικό το έργο 
                                                                                      του αστυνομικού τμήματος (% ποσοστό)."))
                                                                   ))
                                                  ))
                                          ),
                                      tabPanel("Πληροφορίες", tabItem(tabName = "Info",
                                                                      br(),
                                                                      p(style="font-size: 12px;","Χαρτογράφηση της εγκληματικότητας και της ανασφάλειας στην",br(),
                                                                        "εποχή της οικονομικής κρίσης: Τάσεις, διαστάσεις και συσχετισμοί"),
                                                                      p(img(src="urban_logo.png", alt="Urban Crime Logo", 
                                                                            style="width:150px;height:40px;background-color:white;")),
                                                                      br(),
                                                                      p(style="font-size: 12px;","Το έργο χρηματοδοτήθηκε από Το Ελληνικό Ίδρυμα Έρευνας", br(),
                                                                        "και Καινοτομίας (ΕΛ.ΙΔ.Ε.Κ.) στο πλαίσιο της δράσης ", br(),
                                                                        "«1η προκήρυξη ερευνητικών έργων ΕΛ.ΙΔ.Ε.Κ. για την ενίσχυση", br(), 
                                                                        "των μελών ΔΕΠ Και ερευνητών/τριών και την προμήθεια ", br(),
                                                                        "ερευνητικού εξοπλισμού μεγάλης αξίας» "),
                                                                      p(style="font-size: 12px;"," (Αριθμός Έργου: HFRI-FM17-3898)" ),
                                                                      img(src="elidek_logo.png", alt="ΕΛΙΔΕΚ Logo", 
                                                                          style="width:150px;height:44px;background-color:white;") 
                                      ))
                                          )
                          
                          )
                      )
    )
    )

