library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)
library(zoo)
# use session and update selectizeINput to add global portfolios
# use the tabsetPanel to add more panels
function(input, output) {
  datasetInput <- reactive({
    df = ps[ps$date>=as.yearmon(input$dates[1]) & 
              ps$date<=as.yearmon(input$dates[2]),]
    df[,c(-1)] = sapply(df[,c(-1)],  function(x){x/x[1]}) #use input$dates[1] as the initial investment date
    melt_cumret=melt(df,id.vars = c('date'),measure.vars = colnames(df)[-1],variable.name = 'port_name',value.name = 'return')
    melt_cumret[melt_cumret$port_name %in% c(input$old, input$new), ]

  })
  
  output$count <- renderPlot(
    
    ggplot(data = datasetInput()) +
      geom_line(aes(x = date, y = return, color = port_name)) + 
      ylab("Payoff to $1 investment") + scale_x_yearmon()
  )
  
  output$view <- renderTable({
    head(datasetInput())
  })
}


 