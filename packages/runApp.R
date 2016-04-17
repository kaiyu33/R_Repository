#runApp

runApp("F:/GitHub/stockShiny",3000)

# runApp(appDir = getwd(), port = getOption("shiny.port"),
#        launch.browser = getOption("shiny.launch.browser", interactive()),
#        host = getOption("shiny.host", "127.0.0.1"), workerId = "",
#        quiet = FALSE, display.mode = c("auto", "normal", "showcase"))


if (interactive()) {
  # Apps can be run without a server.r and ui.r file
  runApp(list(
    ui = bootstrapPage(
      numericInput('n', 'Number of obs', 100),
      plotOutput('plot')
    ),
    server = function(input, output) {
      output$plot <- renderPlot({ hist(runif(input$n)) })
    }
  ))
  
  
  # Running a Shiny app object
  app <- shinyApp(
    ui = bootstrapPage(
      numericInput('n', 'Number of obs', 100),
      plotOutput('plot')
    ),
    server = function(input, output) {
      output$plot <- renderPlot({ hist(runif(input$n)) })
    }
  )
  runApp(app)
}