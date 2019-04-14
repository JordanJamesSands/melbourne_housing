d = data.frame(x1=factor(c(1,2,2,1,1)),x2=factor(c('a','b','a','a','b')),y=c(1,2,1,1.5,1.2))
mod1 <- lm(y ~ x1 * x2,data=d)
d$inter = interaction(d$x1,d$x2)
mod2 <- lm(y ~ x1 + x2 + inter,data=d)
