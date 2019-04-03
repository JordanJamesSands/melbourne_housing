with(train0,
     plot(jitter(ncar,2),pch=19,col=rgb(as.numeric(imputed_ncar),0,0,0.2 + 0.8*as.numeric(imputed_ncar)))
)

with(train0,
     plot(jitter(nrooms,2),jitter(ncar,2),pch=19,col=rgb(as.numeric(imputed_ncar),0,0,0.2 + 0.8*as.numeric(imputed_ncar)))
)
#with(train0[train0$imputed_ncar==1,],
#     points(jitter(nrooms,2),jitter(ncar,2),pch=19,col=rgb(1,0,0,1))
#)

with(train0,
     plot(jitter(nbathroom,2),jitter(ncar,2),pch=19,col=rgb(as.numeric(imputed_ncar),0,0,0.2 + 0.8*as.numeric(imputed_ncar)))
)
with(train0,
     plot(lat,jitter(ncar,2),pch=19,col=rgb(as.numeric(imputed_ncar),0,0,0.2 + 0.8*as.numeric(imputed_ncar)))
)
with(train0,
     plot(lng,jitter(ncar,2),pch=19,col=rgb(as.numeric(imputed_ncar),0,0,0.2 + 0.8*as.numeric(imputed_ncar)))
)
with(train0,
     plot(log(precomputeddist),jitter(ncar,2),pch=19,col=rgb(as.numeric(imputed_ncar),0,0,0.2 + 0.8*as.numeric(imputed_ncar)))
)
#mod <- lm(ncar ~ nrooms + nbathroom, data=train0)
