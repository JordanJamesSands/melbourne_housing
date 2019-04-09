na_prop = sapply(property_data,function(x){mean(is.na(x))})
na_prop_df = data.frame('feature'=names(na_prop),'prop_na'=na_prop)
na_prop_df = na_prop_df[na_prop_df$prop_na>0,]
na_prop_df = na_prop_df[order(na_prop_df$prop_na),]

#barplot(height=na_prop_df$prop_na,
#        names.arg = na_prop_df$feature,
#        main='Proportion of entries with missing data, per feature',
#        ylim=c(0,1),
#        col='#0892d0',
#        border=NA
#)

