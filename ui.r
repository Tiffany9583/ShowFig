ui <- fluidPage(
  titlePanel("Dr.Wu Lab figure output web"),
  sidebarLayout(
    sidebarPanel(
      # Input: Select a file ----
      fileInput("file1", "Step1. Choose file to upload",
        accept = c(
          "text/csv",
          "text/comma-separated-values",
          "text/tab-separated-values",
          "text/plain",
          ".csv",
          ".tsv"
        )
      ),
      tags$hr(),
      checkboxInput("header", "Header", TRUE),
      radioButtons(
        "sep", "Separator",
        c(
          Comma = ",",
          Semicolon = ";",
          Tab = "\t"
        ),
        ","
      ),
      radioButtons(
        "quote", "Quote",
        c(
          None = "",
          "Double Quote" = '"',
          "Single Quote" = "'"
        ),
        '"'
      ),
    ),
    mainPanel(
      p(
        "If you want a sample .csv or .tsv file to upload,",
        "you can first download the sample",
        a(href = "https://drive.google.com/file/d/1G9vTVlFh7qdOO8CmFjyT8C9RgO9NVdp-/view?usp=sharing", "Example.csv"), "or",
        a(href = "https://drive.google.com/file/d/1GKzLZqPuLi5uCfz3Ak-qc-Itmr3qWUEV/view?usp=sharing", "Example.tsv"),
        "files, and then try uploading them."
      ),
      # Output: Data file ----
      DT::dataTableOutput("contents"),

      # ========================================
      p("Step 2. Select X-axis and Y-axis"),
      uiOutput("selectX"),
      uiOutput("selectY"),
      fluidRow(
        actionButton("Plot", "Plot box", class = "btn-block")
      ),
      # Output:  Figure ----
      plotOutput("showplot", brush = "plot_brush"),
      # Download
      radioButtons(
        "DownloadOption", "Select the Option",
        # c("png", "jpeg", "pdf")
        c("png", "jpeg")
      ),
      downloadButton("downloadPlot")
    )
  )
)