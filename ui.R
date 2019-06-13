
library(shiny)
 
getwd()

fluidPage(
  titlePanel("Infamous Fama-French Portfolios"),
  sidebarLayout(
    sidebarPanel( 
      selectizeInput(
        inputId = "old", 
        label = "Benchmark Portfolio", 
        choices =  colnames(ps)[-1]
        ),
      selectizeInput(
        inputId = "new", 
        label = "Smart Beta Strategies", 
        choices = colnames(ps[-1]) 
        ),
      dateRangeInput(
        "dates", 
        label = ("Date range")
        )
    ),
    mainPanel(
      plotOutput("count"),
      tableOutput("view")
    )
  )
)
