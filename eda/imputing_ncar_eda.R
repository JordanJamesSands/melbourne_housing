with(train0,
     plot(jitter(ncar,2),pch=19,col=rgb(0,0,0,0.2))
)

with(train0,
     plot(jitter(nrooms,2),jitter(ncar,2),pch=19,col=rgb(0,0,0,0.2))
)

with(train0,
     plot(jitter(nbathroom,2),jitter(ncar,2),pch=19,col=rgb(0,0,0,0.2))
)
with(train0,
     plot(lat,jitter(ncar,2),pch=19,col=rgb(0,0,0,0.2))
)
with(train0,
     plot(lng,jitter(ncar,2),pch=19,col=rgb(0,0,0,0.2))
)
with(train0,
     plot(log(precomputeddist),jitter(ncar,2),pch=19,col=rgb(0,0,0,0.2))
)
mod <- lm(ncar ~ nrooms + nbathroom, data=train0)
