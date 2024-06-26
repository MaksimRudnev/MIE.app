
#
#load("dat.R")
#dat<-simMGCFA

requireNamespace("shiny", quietly = F)
requireNamespace("shinyjs", quietly = F)
requireNamespace("markdown", quietly = F)
requireNamespace("shinyWidgets", quietly = F)
requireNamespace("MIE", quietly = F)


# Define UI for application that draws a histogram
shinyUI(
  fluidPage(
    shinyjs::useShinyjs(),
    tags$head(tags$style(
      HTML('
           #sidebar {
           background-color: #dec4de;
           }
           
           label, h2 { 
           font-family: "Verdana";
           }
           form-control.shiny-bound-input {
            font-size: 10pt;
            font-family: monospace;
           }
           span.help-block { 
           font-size: 10pt;
           vertical-align: text-top;
           }
           
           #excludePanel {
           background-color: #CCCCCC30;
           border-bottom-right-radius:10px; 
           padding: 5px;
           margin: 5px;
           }

          #resetExcluded {
            align: "right";
          }

          .buttonHighlighted {
            background-color: #f44336;
            color: white;
          }
           
           ')
  )),
  #tags$head(tags$script(src = "message-handler.js")),
  # Application title
  titlePanel("Measurement invariance explorer"),
  
  tabsetPanel(
    id = 'dataset',
    tabPanel('Invariance explorer',
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      fileInput("file1", "Choose data",
                accept = c(
                  "text/csv",
                  "text/comma-separated-values,text/plain",
                  ".csv", ".txt", ".dat")),
      helpText("First line of data file should contain variable names.
               First variable should be group ID, all the others - indicators.
               Data type: csv, space/tab delimited."),
      actionButton("useSimulated", "Play with fake data instead", icon=icon("magic")),
       hr(),
      uiOutput("formulaArea"),
      checkboxInput("use.formula", "Use this model", value=FALSE),
      actionButton("lavaan.options", "Options"),
       
       
       radioButtons("measure", "Measure of proximity", 
                    choiceNames = c("Covariances (no model implied)",
                                    "Correlations (no model implied)",
                                    "Parameters: loadings (configural MGCFA)",
                                    "Parameters: intercepts (metric MGCFA)",
                                    "Change in fit between configural and metric models (pairwise)",
                                    "Change in fit between metric and scalar models (pairwise)"
                                    ),
                    choiceValues = c("covariance", 
                                     "correlation",
                                     "parameters.loadings", 
                                     "parameters.intercepts",
                                     "fitincrement.metric", 
                                     "fitincrement.scalar"),

                    selected = "covariance"),
      
      #uiOutput("fitindices")
       conditionalPanel(
         condition = "input.measure == 'fitincrement.metric'|input.measure == 'fitincrement.scalar'",
         selectInput("fitincrement.chosen", "Select kind of fit measure",
                     choices=c("CFI"="cfi", "RMSEA"="rmsea", "SRMR"="srmr", "NNFI" = "nnfi", 
                               "GFI" = "gfi", "rmsea.ci.upper" = "rmsea.ci.upper"))
       ),
      hr(),
      checkboxInput("globalMI", "Run global invariance tests for a given subset of groups")

    ),
    
   # selectInput("fitindex", "Select for meausure type: fit indices", 
    #            choices=c("CFI", "RMSEA", "SRMR", "BIC", "TLI", "RFI", "NFI",  ))
    
    # Show a plot of the generated distribution
    mainPanel(

      
       actionLink("zoomIn", "", icon=icon("zoom-in", lib = "glyphicon")),
       
       actionLink("zoomOut", "", icon=icon("zoom-out", lib = "glyphicon")),
       uiOutput("plot"),
       uiOutput("forceFitLink"),
       hr(),
       fluidRow( #tags$style(".well {background-color:#f7ccc;}"),
       #   column(4,
       #          sliderInput("nclusters",
       #                      "Number of clusters:",
       #                      min = 1,
       #                      max = 10,
       #                      value = 2,
       #                      step=1, animate = F, round=T, ticks=F)
       # ),
       
         column(4,        conditionalPanel(
           condition = "input.measure == 'fitincrement.metric'|input.measure == 'fitincrement.scalar'",
           shinyWidgets::materialSwitch(inputId="netSwitch", label = "Use cutoffs?", value = FALSE, 
                          #onLabel = "Distances", offLabel = "Cutoffs"
           ))),
         column(4,
                uiOutput("excluded")
       )),
       
       
       uiOutput("verbatimText"),
       
       hr(),
       uiOutput("table_header"),
       #tableOutput("tabl")
       DT::dataTableOutput('tabl.DT')
       
    )
  )
  
    ), tabPanel("",  icon= icon("question-circle", lib="font-awesome"),
                fluidRow(column(6,
      includeMarkdown("readme.md")))
      )
  , tabPanel("",  icon= icon("copyright"), fluidRow(column(6,includeMarkdown("credits.md"))))
      
      
  
  
)))
