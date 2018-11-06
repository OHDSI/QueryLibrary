library(shiny)

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Testing..."),
  
  sidebarPanel(
    helpText("Panel compute is where I wish for a 'progress bar' to show how much
             time has elapsed.")
  ),
  
  mainPanel(
    
    tabsetPanel(
      tabPanel("Start",value=1),
      tabPanel("Compute", list(
        ### long function
        verbatimTextOutput("intense")),
        value=2),id='panel'),
    ### show timer
    conditionalPanel("updateBusy() || $('html').hasClass('shiny-busy')",
                     id='progressIndicator',
                     "HI I'M IN PROGRESS",
                     div(id='progress',includeHTML("timer.js"))
    ),
    tags$head(tags$style(type="text/css",
                         '#progressIndicator {',
                         '  position: fixed; top: 8px; right: 8px; width: 200px; height: 50px;',
                         '  padding: 8px; border: 1px solid #CCC; border-radius: 8px;',
                         '}'
    ))
  )
  
))