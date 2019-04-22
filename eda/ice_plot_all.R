for(var in names(xgb_train0_x)) {
    print(var)
    ice_plot(model_all,as.matrix(xgb_train0_x),xgb_train0_y,feature=var,frac_to_build = 0.1)
}
