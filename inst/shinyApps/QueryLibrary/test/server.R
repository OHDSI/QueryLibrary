library(shiny)

shinyServer(function(input, output) {
  
  output$intense <- reactivePrint(function() {
    if(input$panel==2){
      Sys.sleep(10)
      return('Finished')
    }else({return(NULL)})
  })
  
})