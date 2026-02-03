library(shiny)

ui <- fluidPage(
  actionButton("run", "Run Calculation"),
  verbatimTextOutput("resultText"),
  verbatimTextOutput("timer")
)

server <- function(input, output, session) {
  # Reactive value to store the elapsed time
  times_elapsed <- reactiveVal(0)
  
  # Observe the button click to run the calculation
  observeEvent(input$run, {
    tm <- system.time({
      # Replace with your long-running code
      plot(1:1000000)
      result <- "Calculation Complete!"
    })
    
    # Store the elapsed time (in seconds)
    times_elapsed(tm['elapsed'])
    # Display the result
    output$resultText <- renderText({
      result
    })
  })
  
  # Display the stored elapsed time
  output$timer <- renderText({
    req(times_elapsed()) # Ensure there is a value to display
    paste0("Executed in: ", round(times_elapsed() * 1000), " milliseconds")
  })
}

shinyApp(ui, server)
