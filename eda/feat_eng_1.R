#hacks for experiments
df = property_data
df = df[1:3,]

#convert these to args in a function
strsearch='park'
distances=c(1000,2000,5000)

#initialise a df of new feats
feat_df = data.frame(matrix(nrow=0,ncol=length(unique(distances))))
names(feat_df) = paste(strsearch,sep='_',distances)

#use a for loop, findplace takes a while anyway
for(rownum in 1:nrow(df)){
    cat(paste('object',rownum,'of',dim(df)[1]),'\n')
    row = df[rownum,]
    #find places using google places api
    feat_obj = findplace(strsearch,row$lat,row$lng,distances = distances)
    #merge with the previouslyy generated features
    names(feat_obj) = paste(strsearch,sep='_',distances)
    feat_df = rbind(feat_df,feat_obj)
}
feat_df
