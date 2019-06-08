
library(shiny)
 
getwd()

fluidPage(
  titlePanel("Infamous Fama-French Portfolios"),
  sidebarLayout(
    sidebarPanel( 
      selectizeInput(
        inputId = "old", 
        label = "Benchmark Portfolio", 
        choices =  colnames(portfolios)[-1]
        ),
      selectizeInput(
        inputId = "new", 
        label = "Smart Beta Strategies", 
        choices = colnames(portfolios[-1]) 
        )
    ),
    mainPanel(
      plotOutput("count")
    )
  )
)
