#this is a hack to optimise the dilation_vector object in the knn_model.R 
#script without actually making it into a function, beware
#
optimise_knn_dilation <- function(vec) {
    print_vec = sapply(vec,function(x){x})
    cat('\n\ndilation_list=\n')
    print(print_vec)
    cat('\n\n')
    DV = list()
    for(featname in names(vec)) {
        DV[[featname]] = vec[names(vec) == featname]
    }
    dilation_list <<- DV
    source('eda/knn_script.R')
    cat(paste0('\n\nRETURNING oof_error=',oof_error,'\n\n'))
    return(oof_error)
}

starting_dilation = list()
for(colname in names(train0_x)) {
    starting_dilation[[colname]]=1
}


optim(par=starting_dilation,
      fn=optimise_knn_dilation,
      method='Nelder-Mead',
      control=list(reltol=0.01))


#starting_dilation = c(nrooms=1,
#                      type_encoded=1,
#                      dist_cbd,
#                      nbathroom=1,
#                      ncar=1,
#                      land_area=1,
#                      building_area=1,
#                      year_built=1,
#                      lat=1,
#                      lng=1,
#                      propcount=1,
#                      imputed_year_built=1,
#                      
#)