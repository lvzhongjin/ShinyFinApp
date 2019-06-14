library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)
library(zoo)
# use session and update selectizeINput to add global portfolios
# use the tabsetPanel to add more panels

function(input, output) {
  datasetInput <- reactive({
    
    melt_cumret=melt(ps,id.vars = c('date'),measure.vars = colnames(ps)[-1],variable.name = 'port_name',value.name = 'return')
    melt_cumret[melt_cumret$port_name %in% c(input$old, input$new), ]

  })
  
  output$count <- renderPlot({
    
    dates = input$slider
    
    ggplot(data = datasetInput()) +
      geom_line(aes(x = as.Date(date), y = return, color = port_name)) + 
      ylab("Payoff to $1 investment") + xlim(dates)
  })
  
  output$view <- renderTable({
    head(datasetInput())
  })
}


 