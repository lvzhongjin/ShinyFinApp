library("data.table")
library(zoo)
library(plyr)
global_portfolios=read.csv("./data/Global_ex_US_ff5_factors.CSV")
portfolios=read.csv("./data/US_ff5_factors.CSV")
summary(portfolios)
portfolios$date=as.yearmon(portfolios$date%/%100+(portfolios$date%%100-1)/12) #date conversion

head(portfolios)
melt_df=melt(portfolios,id.vars = c('date'),measure.vars = colnames(portfolios)[-1],variable.name = 'port_name',value.name = 'return')
head(melt_df)
#convert monthly excess returns in % into cumulative returns
df=portfolios[,c(-1,-ncol(portfolios))]
df0 = lapply(df,  function(x){x+portfolios$RF})
cumret=log(data.frame(df0)/100+1)
cumret=apply(cumret,2,cumsum)
portfolios[,c(-1,-ncol(portfolios))]=exp(cumret)
melt_cumret=melt(portfolios,id.vars = c('date'),measure.vars = colnames(portfolios)[-1],variable.name = 'port_name',value.name = 'return')
