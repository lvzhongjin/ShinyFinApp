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
df = ps[,-ncol(ps)]
melt_df=melt(df,id.vars = c('date'),measure.vars = colnames(df)[-1],variable.name = 'port_name',value.name = 'return')

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
# a=gvisAnnotationChart(melt_df,
#                     datevar="date",
#                     numvar="return",
#                     idvar="port_name",
#                     titlevar="Monthly returns")
# plot(a)




#  
# setDT(melt_df)
# summary_df = melt_df[,.(Ave=mean(return)*12,SD=sd(return)*sqrt(12),Max=max(return),Min=min(return)),by=port_name]
# summary_df$SR=summary_df$Ave/summary_df$SD



