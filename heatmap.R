require(gplots)

cc <- complete.cases(property_data)
df <- property_data[!cc,]

#hack
sum(!cc)
subsample = sample(1:nrow(df),2000)
df <- df[subsample,]

boolmat <- 1*!is.na(df) %>% t()

#hack to make heatmap.2 plot only the heatmap
lmat <- matrix(1:6,nrow=2)
lhei <- c(10, 1)
lwid <- c(10, 1, 1)

plot.new()
heatmap.2(boolmat,
          dendrogram='none',
          trace='none',
          key=F,
          labCol='',
          lmat=lmat,
          lhei=lhei,
          lwid=lwid,
          col=c('#0078D7','#b7b7a5')
          )
