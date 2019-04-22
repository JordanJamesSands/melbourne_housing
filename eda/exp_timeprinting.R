START = Sys.time()
df=data.frame(a=c(1:10))
for(i in 1:nrow(df)) {
    #print(paste('raw=',as.numeric(Sys.time() - START)))
    runtime = as.numeric(difftime(Sys.time(),START,units='secs'))/60
    estimated_runtime = runtime*nrow(df)/i
    perc_complete = round(100*(i-1)/nrow(df),2)
    cat(paste('Computing for object',i,'of',nrow(df),'\n'))
    cat(paste0('Progress: ',perc_complete,'%\n'))
    cat(paste('Total runtime =',round(runtime,2),'minutes','estimated:',
              round(estimated_runtime,2),'minutes','\n'))
    Sys.sleep(10)
}