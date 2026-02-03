# Source - https://stackoverflow.com/a/49925520
# Posted by gianni
# Retrieved 2026-02-03, License - CC BY-SA 3.0

library(shiny)
library(profvis)

profvis({
  
  sApp <- shinyApp(
    
    ui = fluidPage(
      numericInput('n', 'Number of obs', 100, min = 1, max = 200),
      plotOutput('plot')
    ),
    
    server = function(input, output) {
      
      dfTable <- reactive({
        as.data.frame(matrix(rnorm(10 * input$n, mean = 5), ncol = input$n))
      })
      
      vMeans <- reactive({
        apply(dfTable(), 2, mean)
      })
      
      output$plot <- renderPlot({
        hist(vMeans())
      })
    }
  )
  
  runApp(sApp)
})
