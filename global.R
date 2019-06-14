library("data.table")
library(zoo)
library(plyr)
library(dplyr)
global_ps=read.csv("./data/Global_ex_US_ff5_factors.csv")
ps=read.csv("./data/US_ff5_factors.CSV")
head(ps)
head(global_ps)
global_ps$RF=NULL
colnames(global_ps)=lapply(colnames(global_ps), paste0, ".exUS")
 

global_ps = merge(ps, global_ps, by.x = "date",by.y="date.exUS",all.x = T)

ps$date=as.yearmon(ps$date%/%100+(ps$date%%100-1)/12) #date conversion


melt_df=melt(ps,id.vars = c('date'),measure.vars = colnames(ps)[-1],variable.name = 'port_name',value.name = 'return')
head(melt_df)
#convert monthly excess returns in % into cumulative returns
df=ps[,c(-1,-ncol(ps))]
df0 = sapply(df,  function(x){x+ps$RF})
cumret=log(df0/100+1)
cumret=apply(cumret,2,cumsum)
ps[,c(-1,-ncol(ps))]=exp(cumret)

# #test
# df=ps
# melt_cumret=melt(df,id.vars = c('date'),measure.vars = colnames(df)[-1],variable.name = 'port_name',value.name = 'return')
# head(melt_cumret)
# ggplot(data =melt_cumret ) + geom_line(aes(x = date, y = return, color = port_name))+ ylab("Payoff to $1 investment")+scale_x_yearmon()
#  