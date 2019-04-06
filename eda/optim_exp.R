obj_fun <- function(vec) {
    A = list()
    for(colname in names(vec)) {
        A[[colname]] = vec[colname == names(vec)]
    }
    val = (A$a-7)^2 + (A$b-5)^2 + (A$c+1)^2 + 3
    names(val) = NULL
    return (val)
}

opt = optim(par=c(a=1,b=2,c=3),
            fn=obj_fun,
            method='Nelder-Mead',
            control=list(reltol=1e-5)
            )
print(opt)
