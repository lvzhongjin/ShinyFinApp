library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)
library(zoo)
library(googleVis)
# use session and update selectizeINput to add global portfolios

# Problems with Gvis: 
  # 1. unable to add title via titlevar="Monthly returns"
  # 2. More difficult: Gvis chart is not "embedded"
# Problems with Portfolio Performance Table: 
  # Need annotation to explain the statistics 
 

# use the tabsetPanel to add more panels (by Sam)
# add slider for time range (by Sam)
# fix cumulative when time range is changed (by Zhongjin)

function(input, output) {
  datasetInput <- reactive({
    df = ps[ps$date>=as.yearmon(input$slider[1]) & 
              ps$date<=as.yearmon(input$slider[2]),]
    df[,c(-1)] = sapply(df[,c(-1)],  function(x){x/x[1]}) #use input$dates[1] as the initial investment date
    melt_cumret=melt(df,id.vars = c('date'),measure.vars = colnames(df)[-1],variable.name = 'port_name',value.name = 'return')
    melt_cumret[melt_cumret$port_name %in% c(input$old, input$new), ]

  })
  
  MonthlyRet <- reactive({
    melt_df[between(melt_df$date,as.yearmon(input$slider[1]),as.yearmon(input$slider[2])), ]
  })
  
  
  output$count <- renderPlot({
    
    dates = input$slider
    
    ggplot(data = datasetInput()) +
      geom_line(aes(x = as.Date(date), y = return, color = port_name)) + 
      ylab("Payoff to $1 investment") + xlim(dates) + xlab("Investment Horizon")
  })
  
  output$gvis <- renderPlot({
 plot(gvisAnnotationChart(MonthlyRet(), 
                              datevar="date",
                              numvar="return", 
                              idvar="port_name") 
 )
    
  })
  
  output$view <- renderTable({
    df=MonthlyRet()
    setDT(df)
    summary_df = df[,.(Ave=mean(return),SD=sd(return),Max=max(return),Min=min(return)),by=port_name]
    summary_df$SR=summary_df$Ave/summary_df$SD
    setnames(summary_df,"port_name","FF Portfolios")
    summary_df
    #head(datasetInput())
  })
}


 