
ui <- dashboardPage(
  
  dashboardHeader(title = div(img(src="logo.png", height = 50, width = 50), "QueryLibrary")),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "select", icon = icon("home")),
      menuItem("Configuration", tabName = "configuration", icon = icon("cog")),
      menuItem("Feedback", icon = icon("comment"), href = "https://github.com/mi-erasmusmc/OMOP-Queries/issues")
    ),
    tags$footer(
      align = "right",
      style = "
      position:absolute;
      bottom:0;
      width:100%;
      height:175px;
      color: black;
      padding: 10px;
      text-align:center;
      background-color: #eee;
      z-index: 1000;",
      HTML(
        "<a href=\"https://www.apache.org/licenses/LICENSE-2.0\">Apache 2.0</a>
        <div style=\"margin-bottom:10px;\">open source software</div>
        <div>provided by</div>
        <div><a href=\"http://www.ohdsi.org\"><img src=\"ohdsi_color.png\" height=42 width = 100></a></div>
        <div><a href=\"http://www.ohdsi.org\">join the journey</a> </div>
        <div>"
      )
    )
  ),
  
  dashboardBody(
    useShinyjs(),
    tags$head(
      tags$style(
        HTML(".shiny-notification {
             color:red;
             position:fixed;
             top: calc(12%);;
             left: calc(50%);;
             width: calc(45%);;
             }
             "
        )
      )
    ),
    tabItems(
      tabItem(
        tabName = "select",
        tabsetPanel(
          tabPanel("Select",
            h2("Select a query"),
            fluidRow(
              column(
                label = 'selectedQuery',
                width = 6,
                offset = 0,
                #actionButton("clearFiltersButton","Clear All Filters"),
                DTOutput("queriesTable")
              ),
              column(
                width = 6,
                box(
                  title = "Query Description",
                  width = NULL,
                  status = "primary",
                  uiOutput(outputId = "html")
                )
              )
            )
          )
# DISABLE EXECUTE          ,  
# DISABLE EXECUTE          tabPanel(
# DISABLE EXECUTE            "Execute",
# DISABLE EXECUTE            box(
# DISABLE EXECUTE              title = "Execute",
# DISABLE EXECUTE              width = NULL,
# DISABLE EXECUTE              height = '80%',
# DISABLE EXECUTE              actionButton("importButton", "Import selected query", icon = icon("home")),
# DISABLE EXECUTE              textAreaInput("target", NULL, ""),
# DISABLE EXECUTE              actionButton("executeButton", "Run", icon = icon("play")),
# DISABLE EXECUTE              buttonCopyTextAreaToClipboard("copyClipboardButton","target","Copy query to clipboard"),
# DISABLE EXECUTE              buttonDownloadTextArea("save","target","Save query to file")
# DISABLE EXECUTE            ),
# DISABLE EXECUTE                  
# DISABLE EXECUTE            ### show timer
# DISABLE EXECUTE            conditionalPanel(
# DISABLE EXECUTE              "updateBusy() || $('html').hasClass('shiny-busy')",
# DISABLE EXECUTE              id='progressIndicator',
# DISABLE EXECUTE              "Running",
# DISABLE EXECUTE              div(id='progress',includeHTML("timer.js"))
# DISABLE EXECUTE            ),
# DISABLE EXECUTE
# DISABLE EXECUTE            tags$head(
# DISABLE EXECUTE              tags$style(
# DISABLE EXECUTE                type="text/css",
# DISABLE EXECUTE                '#progressIndicator {',
# DISABLE EXECUTE                  # '  position: fixed; top: 120px; right: 80px; width: 170px; height: 60px;',
# DISABLE EXECUTE                  '  padding: 8px; border: 1px solid # DISABLE EXECUTECCC; border-radius: 8px; color:green',
# DISABLE EXECUTE                '}'
# DISABLE EXECUTE              )
# DISABLE EXECUTE            ),
# DISABLE EXECUTE
# DISABLE EXECUTE            box(
# DISABLE EXECUTE              title = "Results",
# DISABLE EXECUTE              width = NULL,
# DISABLE EXECUTE              height = '80%',
# DISABLE EXECUTE              tableOutput("resultsTable")# DISABLE EXECUTE,
# DISABLE EXECUTE              #downloadButton('downloadData', 'Download Results')
# DISABLE EXECUTE            )
# DISABLE EXECUTE          )
        )
    
      ),
      
      tabItem(
        tabName = "configuration",
        h2("Configuration"),
# DISABLE EXECUTE        shinyFilesButton("loadConfig", "Load", "Select Configuration file", multiple = FALSE),
# DISABLE EXECUTE        shinySaveButton("saveConfig", "Save", "Save file as...", filename = configFilename, filetype = list(settings = "Rds")),
        # fluidRow(
        #   offset = 10,
        #   column(
        #     width = 6,
        #     box(
        #       background = "light-blue",
        #     
        #       width = NULL,
        #       h4("user queries folder"),
        #       textInput("userFolder", NULL),
        #       shinyDirButton("selectUserFolder", "Select", "Select folder containing user-defined query files")
        #     )
        #   )
        # ),
        
        fluidRow(
          offset = 5,
          column(
            width = 6,
            box(
              background = "light-blue",
                
              width = NULL,
              h4("target dialect"),
              selectInput(
                "dialect",
                NULL,
                choices = c(
                  "BigQuery",
                  "Impala",
                  "Netezza",
                  "Oracle",
                  "PDW",
                  "PostgreSQL",
                  "RedShift",
                  "SQL Server"
                ),
                selected = "SQL Server"
              ),
                
# DISABLE EXECUTE              h4("server"),
# DISABLE EXECUTE              textInput("server", NULL),
# DISABLE EXECUTE                
# DISABLE EXECUTE              h4("username"),
# DISABLE EXECUTE              textInput("user", NULL),
# DISABLE EXECUTE                
# DISABLE EXECUTE              h4("password"),
# DISABLE EXECUTE              passwordInput("password", NULL),
# DISABLE EXECUTE                
# DISABLE EXECUTE              h4("port"),
# DISABLE EXECUTE              textInput("port", NULL, value = 1521),
                
              h4("cdm schema"),
              textInput("cdm", NULL, value = "cdm"),
                
              h4("vocabulary schema"),
              textInput("vocab", NULL, value = "cdm")
# DISABLE EXECUTE              ,
# DISABLE EXECUTE                
# DISABLE EXECUTE              h4("Oracle temp schema"),
# DISABLE EXECUTE              textInput("oracleTempSchema", NULL),
# DISABLE EXECUTE                
# DISABLE EXECUTE              h4("extra setting"),
# DISABLE EXECUTE              textInput("extraSettings", NULL),
# DISABLE EXECUTE                
# DISABLE EXECUTE              actionButton("testButton","Test Connection")
                
            )
# DISABLE EXECUTE            ,
# DISABLE EXECUTE              
# DISABLE EXECUTE            textOutput("connected"),
# DISABLE EXECUTE            textOutput("warnings")
          )
        )
      )
    )
  )
)