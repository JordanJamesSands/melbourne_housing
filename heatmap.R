cc <- complete.cases(property_data)
NA_data <- property_data[!cc,]
is_na <- 1*is.na(NA_data) %>% t()

#HACK
is_na <- is_na[,sample(1:ncol(is_na),1000)]

#hack to make heatmap.2 plot only the heatmap
lmat <- matrix(1:6,nrow=2)
lhei <- c(10, 1)
lwid <- c(10, 1, 1)

#create plot
plot.new()
png('na_heatmap.png',width=1000,height=1000)
heatmap.2(is_na,
          dendrogram='none',
          trace='none',
          key=F,
          labCol='',
          cexRow=2,
          lmat=lmat,
          lhei=lhei,
          lwid=lwid,
          col=c('#b7b7a5','#0078D7')
)
dev.off()