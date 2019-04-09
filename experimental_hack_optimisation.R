testfun <- function(input_vec) {
    A = list()
    A$a=input_vec['a'==names(input_vec)]
    A$b=input_vec['b'==names(input_vec)]
    A$c=input_vec['c'==names(input_vec)]
    A <<- A
    source('eda/test_exp.R')
    return(val)
}
optim(c(a=1,b=1,c=1),testfun)
