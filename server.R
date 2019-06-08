library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)
 

function(input, output) {
  output$count <- renderPlot(
    ggplot(data = melt_cumret[melt_cumret$port_name %in% c(input$old, input$new), ])
    + geom_line(aes(x = date, y = return, color = port_name))+ ylab("Payoff to $1 investment")
  )
}


 