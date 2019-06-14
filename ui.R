
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
      
      sliderInput("slider", 
                  "Time", 
                  min = as.Date("1963-07-01"),
                  max =as.Date("2019-04-01"),
                  value=as.Date(c("1994-07-01", "2000-01-01")),
                  timeFormat="%b %Y",
                  width = "90%")
  
    ),
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Plot", plotOutput("count")),
                  tabPanel("GvisPlot", plotOutput("gvis")),
                  tabPanel("Portfolio Performance", tableOutput("view"))
      )
    )
  )
)
