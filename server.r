server <- function(input, output, session) {
  # Bot plot==================================
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
    selectInput(inputId = "selectY", label = "select Y-axis", choices = names(rv$data))
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

  # PCA plot==================================
  # read data and show table
  rv <- reactiveValues(data = NULL)

  output$PCA_contents <- DT::renderDataTable({
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

  # input all parameters
  output$select_parameter <- renderUI({
    req(rv$data)
    Parameter <- c(names(rv$data))
    checkboxGroupInput("Parameter", "Parameters", Parameter)
  })
  # input groups vacter
  observeEvent(input$Parameter, {
    output$select_groups <- renderUI({
      selectInput(inputId = "select_groups", label = "select_groups", choices = input$Parameter)
    })
  })

  # do pca analysis and plot
  plotInput_PCA <- function() {
    req(rv$data)
    data_PCA <- rv$data
    Parameter <- input$Parameter[input$Parameter != input$select_groups] # without select_groups

    rownames(data_PCA) <- data_PCA$Name
    data_PCA <- subset(data_PCA, select = -Name)
    data_PCA_Parameter <- data_PCA[, Parameter] # extract specific column
    data_PCA_Parameter <- data.matrix(data_PCA_Parameter)

    # make pca plot
    groups <- as.factor(data_PCA[, input$select_groups])

    pca <- prcomp(data_PCA_Parameter) # do pca
    # str(pca)
    fviz_pca_biplot(pca,
      repel = TRUE,
      col.ind = groups, # 依據群組上色
      addEllipses = TRUE, # 加上橢圓
      ellipse.type = "confidence", # 橢圓類型
      mean.point = FALSE, # 關掉平均值的點
      col.var = "black",
      title = "",
      legend.title = input$select_groups,
    ) +
      theme_classic(base_size = 18) +
      theme(
        legend.text = element_text(face = "italic"),
        # plot.tag = element_text(face = "italic"),
        axis.text.x = element_text(size = 14, face = "bold"),
        axis.text.y = element_text(size = 14, face = "bold")
      )
  }

  observeEvent(input$Plot_PCA, {
    output$showplot_PCA <- renderPlot(
      {
        plotInput_PCA()
      },
      res = 96
    )
  })

  output$downloadPlot_PCA <- downloadHandler(
    filename = function() {
      paste("Plot", input$DownloadOption_PCA, sep = ".")
    },
    # if (input$DownloadOption == "pdf") {
    #   pdf(filename)
    #   print(plotInput())
    #   dev.off()
    # } else {
    content <- function(file) {
      device <- function(..., width, height) grDevices::png(..., width = width, height = height, res = 300, units = "in")
      ggsave(file, plot = plotInput_PCA(), device = device)
    }
  )

  # regression plot==================================
  rv <- reactiveValues(data = NULL)

  output$Re_contents <- DT::renderDataTable({
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

  output$Re_selectX <- renderUI({
    req(rv$data)
    selectInput(inputId = "Re_selectX", label = "select X-axis", choices = names(rv$data))
  })

  output$Re_selectY <- renderUI({
    req(rv$data)
    selectInput(inputId = "Re_selectY", label = "select Y-axis", choices = names(rv$data))
  })

  output$Re_select_groups <- renderUI({
    req(rv$data)
    selectInput(inputId = "Re_select_groups", label = "select groups", choices = names(rv$data))
  })

  Re_plotInput <- function() {
    req(rv$data)
    Re_data <- rv$data
    groups <- as.factor(Re_data[, input$Re_select_groups])
    Re_data <- data.frame(
      groups = Re_data[, input$Re_select_groups],
      x = Re_data[, input$Re_selectX],
      y = Re_data[, input$Re_selectY]
    )

    print(Re_data)

    ggplot(Re_data, aes(x, y)) +
      geom_point(aes(colour = groups), size = 3) +
      geom_smooth(method = "lm") +
      theme_classic() +
      # geom_text(aes(label = Name)) +
      xlab(input$Re_selectX) +
      ylab(input$Re_selectY) +
      labs(color = input$Re_select_groups)
  }

  observeEvent(input$Re_Plot, {
    output$Re_showplot <- renderPlot(
      {
        Re_plotInput()
      },
      res = 96
    )
  })

  output$Re_downloadPlot <- downloadHandler(
    filename = function() {
      paste("Plot", input$Re_DownloadOption, sep = ".")
    },
    # if (input$DownloadOption == "pdf") {
    #   pdf(filename)
    #   print(plotInput())
    #   dev.off()
    # } else {
    content <- function(file) {
      device <- function(..., width, height) grDevices::png(..., width = width, height = height, res = 300, units = "in")
      ggsave(file, plot = Re_plotInput(), device = device)
    }
  )
}