library(DT)
library(shiny)
library(ggplot2)
library(ggpubr)
library(ade4)
library(factoextra)
library(magrittr)

# game.R needs to be loaded first

# source("R/game.R")
# source("ai.R")
source("ui.r")
source("server.r")

shinyApp(ui, server)