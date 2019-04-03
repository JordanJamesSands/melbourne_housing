already_existed = !is.na(train0$year_built)
all(train0_impyear[already_existed,]$year_built == train0[already_existed,]$year_built)

par(bg='white')
with(train0,
     plot(year_built,log(price),pch=19,col=rgb(imputed_year_built,0,0,0.2))
)
