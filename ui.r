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
      tabsetPanel(
        id = "tabs",
        tabPanel(
          title = "Box plot",
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
            actionButton("Plot", "Step 4. Plot box", class = "btn-block")
          ),
          # Output:  Figure ----
          plotOutput("showplot", brush = "plot_brush"),
          # Download
          radioButtons(
            "DownloadOption", "Step 5. Select options for download.",
            # c("png", "jpeg", "pdf")
            c("png", "jpeg")
          ),
          downloadButton("downloadPlot")
        ),
        tabPanel(
          # PCR plot========================================
          title = "PCR plot",
          p(
            "If you want a sample .csv ,",
            "please download the sample",
            a(href = "https://drive.google.com/file/d/1KKELOxQAyu0fsLJ2MMCY9Wd2ETPhDqET/view?usp=sharing", "Example.csv"),
            "files, and then try to upload your data after modifying it."
          ),
          # Output: Data file ----
          DT::dataTableOutput("PCA_contents"),

          # Select all parameters
          p("Step 2. Select the parameter you want to attend to analysis."),
          uiOutput("select_parameter"),

          # Select groups
          p("Step 3. Select the parameter you want to do for the cluster."),
          uiOutput("select_groups"),
          fluidRow(
            actionButton("Plot_PCA", "Step 4. Plot PCA", class = "btn-block")
          ),

          # Output:  Figure ----
          plotOutput("showplot_PCA", brush = "plot_brush"),

          # Download
          radioButtons(
            "DownloadOption", "Step 5. Select options for download.",
            # c("png", "jpeg", "pdf")
            c("png", "jpeg")
          ),
          downloadButton("downloadPlot_PCA")
        )
      )
    )
  )
)