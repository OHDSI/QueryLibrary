library(shiny)
library(shinydashboard)
library(shinyFiles)
library(shinyjs)
library(SqlRender)
library(DatabaseConnector)
library(DT)
source("widgets.R")
source("helpers.R")
source("markdownParse.R")

queryFolder <- "./queries"
configFilename <- "settings.Rds"
allow_execute <- TRUE
tempFolder <- paste0(getwd(), "/www")
if (grepl("shiny-server", getwd(), fixed = TRUE)) {
  tempFolder <- "/tmp"
}
if (tempFolder != paste0(getwd(), "/www")) {
  file.copy(paste0(getwd(), "/www/rendered.css"), tempFolder)
}

queriesDf <- loadQueriesTable(queryFolder, "")
mdFiles <- list.files(queryFolder, recursive = TRUE, pattern = "*.md")
mdFiles <- paste(queryFolder, mdFiles, sep = "/")
