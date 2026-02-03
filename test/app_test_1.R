# Source - https://stackoverflow.com/a/27664673
# Posted by jdharrison
# Retrieved 2026-02-03, License - CC BY-SA 3.0

library(shiny)
runApp(list(
  ui = bootstrapPage(
    numericInput('n', 'Number of obs', 100),
    plotOutput('plot')
  ),
  server = function(input, output) {
    output$plot <- renderPlot({
      beginning <- Sys.time()
      h <- hist(runif(input$n)) 
      end <- Sys.time()
      print(end - beginning)
      h
    })
  }
))
