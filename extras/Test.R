
library(SqlRender)
library(DatabaseConnector)
library(DT)

setwd("D:/Documents/Github/QueryLibrary/inst/shinyApps/QueryLibrary")

source("widgets.R")
source("helpers.R")
source("markdownParse.R")

queryMainFolder <- "./queries"
querySubFolders <- c("care_site",
                     "condition",
                     "condition_era",
                     "condition_occurence",
                     "condition_occurrence_combinations",
                     "drug",
                     "drug_cost",
                     "drug_era",
                     "drug_exposure",
                     "general",
                     "obervation_period",
                     "observation",
                     "payer_plan",
                     "person",
                     "procedure")
databaseFolder <- "./testdatabases"

mdFiles <- c()
if (length(querySubFolders) > 0) {
  first <- TRUE
  for (querySubFolder in querySubFolders) {
    queryFolder <- paste(queryMainFolder, querySubFolder, sep = "/")
    subFolderQueriesDf <- loadQueriesTable(queryFolder, "")
    subFolderMdFiles <- list.files(queryFolder, recursive = TRUE, pattern = "*.md")
    subFolderMdFiles <- paste(queryFolder, subFolderMdFiles, sep = "/")

    if (first) {
      queriesDf <- subFolderQueriesDf
      mdFiles <- subFolderMdFiles
    } else {
      queriesDf <- rbind(queriesDf, subFolderQueriesDf)
      mdFiles <- c(mdFiles, subFolderMdFiles)
    }

    first <- FALSE
  }
} else {
  queriesDf <- loadQueriesTable(queryMainFolder, "")
  mdFiles <- list.files(queryMainFolder, recursive = TRUE, pattern = "*.md")
  mdFiles <- paste(queryMainFolder, mdFiles, sep = "/")
}

databases <- list.files(databaseFolder, recursive = FALSE, pattern = "*.Rds")

testResult <- NULL

first <- TRUE
if (length(databases) > 0) {
  for (database in databases) {
    if (first) {
      writeLines(paste0("Working directory: ", getwd()))
      writeLines(paste0("Query main folder: ", queryMainFolder))
      writeLines(paste0("Database folder  : ", databaseFolder))
      writeLines("")
      first <- FALSE
    }

    databaseName <- substr(database, 1, nchar(database) - 4)
    writeLines(paste0("Testing database ", databaseName))

    databaseParameters <- readRDS(paste(databaseFolder, database, sep = "/"))

    connectionDetails <- createConnectionDetails(dbms = tolower(databaseParameters$dialect),
                                                 user = databaseParameters$user,
                                                 password = databaseParameters$password,
                                                 server = databaseParameters$server,
                                                 port = databaseParameters$port,
                                                 extraSettings = databaseParameters$extraSettings)

    schemaDefinition <- list(cdm = databaseParameters$cdm, vocab = databaseParameters$vocab)

    for (mdFile in mdFiles) {
      writeLines("  ", sep = "")
      connection <- DatabaseConnector::connect(connectionDetails)
      start <- Sys.time()
      queryResult <- testQuery(mdFile = mdFile,
                               connectionDetails = connectionDetails,
                               connection = connection,
                               inputValues = schemaDefinition,
                               oracleTempSchema = "")
      end <- Sys.time()
      duration <- as.numeric(difftime(end, start, unit = "secs"))
      writeLines(paste0("    ", mdFile, ": ", queryResult, " (", duration, " secs)"))
      queryID <- strsplit(mdFile, "/")[[1]][4]
      queryID <- strsplit(substr(queryID, 1, nchar(queryID) - 3)[1], "_")[[1]][1]
      if (is.null(testResult)) {
        testResult <- data.frame(databaseName,
                                 databaseParameters$dialect,
                                 mdFile,
                                 queryID,
                                 queryResult,
                                 duration)
      } else {
        queryTestResult <- data.frame(databaseName,
                                      databaseParameters$dialect,
                                      mdFile,
                                      queryID,
                                      queryResult,
                                      duration)
        testResult <- rbind(testResult, queryTestResult)
      }
      disconnect(connection)
    }

    writeLines("")
  }

  names(testResult) <- c("Database", "Dialect", "Query file", "ID", "Result", "Duration (secs)")
  write.csv(testResult, file = "Test Result.csv", row.names = FALSE)
  # print(testResult)
} else {
  print("No database definitions found!")
}
