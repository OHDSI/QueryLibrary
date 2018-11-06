library(shiny)

server <- shinyServer(function(input, output, session) {
  
  output$downloadData <- downloadHandler(
    filename = function() { 
      paste("dataset-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(input$target, file)
    })
})

ui <- shinyUI(fluidPage(
  textAreaInput("target", NULL, ""),
  downloadButton('downloadData', 'Download data')
))

shinyApp(ui=ui,server=server)