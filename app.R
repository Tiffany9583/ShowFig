library(DT)
library(shiny)
library(ggplot2)
library(ggpubr)

# game.R needs to be loaded first

# source("R/game.R")
# source("ai.R")
source("ui.R")
source("server.R")

shinyApp(ui, server)