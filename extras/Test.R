
library(SqlRender)
library(DatabaseConnector)

setwd("D:/Documents/Github/QueryLibrary/inst/shinyApps/QueryLibrary")

queryFolder = "./queries"
databaseFolder = "./testdatabases"

queriesDf = loadQueriesTable(queryFolder,"")
mdFiles = list.files(queryFolder, recursive = TRUE, pattern='*.md')[1:3]
mdFiles = paste(queryFolder, mdFiles, sep="/")

databases = list.files(databaseFolder, recursive=FALSE, pattern='*.Rds')

testResult = NULL

writeLines(paste0("Working directory: ", getwd()))
writeLines(paste0("Query folder     : ", queryFolder))
writeLines(paste0("Database folder  : ", databaseFolder))
writeLines("")

if (length(databases) > 0) {
  for (database in databases) {
    databaseName <- substr(database, 1, nchar(database) - 4)
    writeLines(paste0("Testing database ", databaseName))
    
    databaseParameters <- readRDS(paste(databaseFolder, database, sep="/"))
    
    connectionDetails <- createConnectionDetails(dbms = tolower(databaseParameters$dialect),
                                                 user = databaseParameters$user,
                                                 password = databaseParameters$password,
                                                 server = databaseParameters$server,
                                                 port = databaseParameters$port,
                                                 extraSettings = databaseParameters$extraSettings)
    connection <- DatabaseConnector::connect(connectionDetails)
    
    schemaDefinition <- list(cdm = databaseParameters$cdm, vocab = databaseParameters$vocab)
    
    for (mdFile in mdFiles) {
      start <- Sys.time()
      queryResult <- testQuery(mdFile=mdFile, connectionDetails=connectionDetails, connection=connection, inputValues=schemaDefinition, oracleTempSchema="")
      end <- Sys.time()
      duration <- as.numeric(difftime(end, start, unit="secs"))
      writeLines(paste0("  ", mdFile, ": ", queryResult, " (", duration, " secs)"))
      if (is.null(testResult)) {
        testResult <- data.frame(databaseName, databaseParameters$dialect, mdFile, queryResult, duration)
      } else {
        queryTestResult <- data.frame(databaseName, databaseParameters$dialect, mdFile, queryResult, duration)
        testResult <- rbind(testResult, queryTestResult)
      }
    }
    
    disconnect(connection)
    writeLines("")
  }
  
  names(testResult) <- c("Database", "Dialect", "Query file", "Result", "Duration (secs)")
  write.csv(testResult, file = "Test Result.csv", row.names = FALSE)
  #print(testResult)
} else {
  print("No database definitions found!")
}