server <- function(input, output, session) {
  rv <- reactiveValues(data = NULL)

  output$contents <- DT::renderDataTable({
    inFile <- input$file1

    if (is.null(inFile)) {
      return(NULL)
    }

    rv$data <- read.csv(inFile$datapath,
      header = input$header,
      sep = input$sep, quote = input$quote, fileEncoding = "UTF-8-BOM"
    )
    # rv$data <- read.csv(inFile$datapath, header = TRUE, sep = ",", fileEncoding = "UTF-8-BOM")
  })

  output$selectX <- renderUI({
    req(rv$data)
    selectInput(inputId = "selectX", label = "select X-axis", choices = names(rv$data))
  })

  output$selectY <- renderUI({
    req(rv$data)
    selectInput(inputId = "selectY", label = "select Y-axi", choices = names(rv$data))
  })

  plotInput <- function() {
    req(rv$data)
    ggboxplot(rv$data,
      x = input$selectX, y = input$selectY,
      color = input$selectX, palette = "npg"
    )
  }

  observeEvent(input$Plot, {
    output$showplot <- renderPlot(
      {
        plotInput()
      },
      res = 96
    )
  })

  output$downloadPlot <- downloadHandler(
    filename = function() {
      paste("Plot", input$DownloadOption, sep = ".")
    },
    # if (input$DownloadOption == "pdf") {
    #   pdf(filename)
    #   print(plotInput())
    #   dev.off()
    # } else {
    content <- function(file) {
      device <- function(..., width, height) grDevices::png(..., width = width, height = height, res = 300, units = "in")
      ggsave(file, plot = plotInput(), device = device)
    }
  )
}