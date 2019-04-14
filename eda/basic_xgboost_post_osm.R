#------------------------Functions------------------------------------------
plot_cv <- function(cv_obj,xlim=NULL,ylim=NULL) {
    eval_data = cv_obj$evaluation_log
    if(is.null(xlim)){ xlim=range(eval_data$iter) }
    if(is.null(ylim)) {ylim=range(eval_data[,c(2,4)])}
    plot(NULL,NULL,type='n',xlim=xlim,ylim=ylim,ylab='rmse')
    
    #plot train
    lines(eval_data[,2],col='green',lwd=2)
    lines(eval_data[,2]-eval_data[,3],col='green',lwd=2,lty=2)
    lines(eval_data[,2]+eval_data[,3],col='green',lwd=2,lty=2)
    
    #plot test
    lines(eval_data[,4],col='red',lwd=2)
    lines(eval_data[,4]-eval_data[,5],col='red',lwd=2,lty=2)
    lines(eval_data[,4]+eval_data[,5],col='red',lwd=2,lty=2)
    
    abline(v=0,lwd=1,lty=4)
    
    min_test_error = min(eval_data[,4])
    
    #add sd lines
    best_iter = cv_obj$best_iteration
    sd_line_dist = eval_data[best_iter,5]
    abline(h=min_test_error+sd_line_dist,lwd=1,lty=2)
    abline(h=min_test_error-sd_line_dist,lwd=1,lty=2)
    text(x=0.5*xlim[2],y=min_test_error+sd_line_dist+0.05,round(min_test_error+sd_line_dist,4))
    text(x=0.5*xlim[2],y=min_test_error-sd_line_dist-0.05,round(min_test_error-sd_line_dist,4))
    #############
    
    abline(h=min_test_error,lwd=1,lty=2)
    text(x=0.05*xlim[2],y=min_test_error-0.005,round(min_test_error,4))
}

#-----------------------load dependencies and declare global vars-------------
library(caret)
library(xgboost)
library(pdp)
library(vip)
library(dplyr)

#---------------------prepare data for xgboost api---------------------------
train0_xgb_prep = encode_type(train0)
#train0_xgb_prep = select_cols(train0_xgb_prep,numeric_only = T,
#                              extra_feature_names ='ntrain_3000',
#                              include_impute_flags = F)
#train0_x = select(train0_xgb_prep,-price)

#------------------new
MELBOURNE_CENTRE = c(144.9631,-37.8136)
train0_xgb_prep <- polarise(MELBOURNE_CENTRE,train0_xgb_prep)

features <- c('building_area'
              #,'lng'
              #,'lat'
              ,'dist_cbd'
              ,'bearing'
              ,'year_built'
              ,'type_encoded'
              ,'nrooms'
              ,'land_area'
              #,'method_encoded'
              ,'nbathroom'
              ,'ncar'
              
              #,'nbar_1000'
              #,'bar_min_dist'
              
              #,'nbbq_1000'
              #,'bbq_min_dist'
              
              #,'ncafe_1000'
              #,'cafe_min_dist'
              
              #,'nkindergarten_2000'
              #,'kindergarten_min_dist'
              
              #,'nschool_2000'
              ,'school_min_dist'
              
              #,'ntrain_3000'
              ,'train_min_dist'
              
              #,'nsupermarket_2000'
              #,'supermarket_min_dist'
)

train0_y = log(train0_xgb_prep$price)
train0_x <- train0_xgb_prep %>% select(features)
#-------------------------


#-------------------------HACK------------------
#train0_x <- polarise(train0_x)

#train0_x <- select(train0_x,-dist_cbd)
#-----------------------------------------------
#train0_y = log(train0_xgb_prep$price)

Dtrain0 = xgb.DMatrix(data=as.matrix(train0_x),label=train0_y)

#--------------- Write parameters-----------------------------
PARAMS = list(
    seed=0,
    objective='reg:linear',
    eta=0.05,
    eval_metric='rmse',
    max_depth=6,
    colsample_bytree=0.8,
    subsample=0.8
    
)

set.seed(457835)
#------------------------cross validation-------------------------
cv_obj = xgb.cv(params=PARAMS,
                data=Dtrain0,
                folds=folds,
                verbose=T,
                nrounds=1e+6,
                early_stopping_rounds=200
)
plot_cv(cv_obj,ylim=c(0,0.3))
#break
#-----------------------------plot----------------------------------------------
#ggplot(eval_log,aes(x=iter)) + 
#    coord_cartesian(ylim=c(0.1,0.4)) +
#    geom_line(aes(y=train_rmse_mean),lwd=2,col='#0078D7') +
#    geom_line(aes(y=train_rmse_mean + train_rmse_std),lwd=1,col='#0078D7',lty=1) +
#    geom_line(aes(y=train_rmse_mean + train_rmse_std),lwd=1,col='#0078D7',lty=1) +
#    geom_line(aes(y=test_rmse_mean),lwd=2,col='orange') +
#    geom_line(aes(y=test_rmse_mean + test_rmse_std),lwd=1,col='orange',lty=2) +
#    geom_line(aes(y=test_rmse_mean - test_rmse_std),lwd=1,col='orange',lty=2) 
#---------------------------Fit KFOLD many models--------------------------
OPTIMAL_NROUNDS=cv_obj$best_ntreelimit
xgb_oof_preds = rep(NA,nrow(train0))
for (i in 1:KFOLD) {
    cat(paste('fold number:',i,'of',KFOLD,'\n'))
    fold = folds[[i]]
    
    train0_x_fold = train0_x[-fold,]
    train0_y_fold = train0_y[-fold]
    Dtrain0_fold = xgb.DMatrix(data=as.matrix(train0_x_fold),label=train0_y_fold)
    
    val0_x_fold = train0_x[fold,]
    val0_y_fold = train0_y[fold]
    Dval0_fold = xgb.DMatrix(data=as.matrix(val0_x_fold),label=val0_y_fold)
    
    
    model = xgb.train(params=PARAMS,
                      data=Dtrain0_fold,
                      nrounds=OPTIMAL_NROUNDS,
                      verbose=0)
    
    preds = predict(model,newdata=Dval0_fold)
    #plot(preds,val0_y_fold,main=paste('fold',i))
    cat('true/predicted correlation:',cor(preds,val0_y_fold),'\n')
    rmse = sqrt(mean((preds-val0_y_fold )^2))
    cat('rmse:',rmse,'\n')
    
    xgb_oof_preds[fold] = preds
}
xgb_oof_error <- sqrt(mean((xgb_oof_preds-train0_y )^2))
cat('rmse OOF predictions:',xgb_oof_error,'\n')

#---- train model on all train0------------------

#model_all_old = xgb.train(params=PARAMS,
#                      data=Dtrain0,
#                      nrounds=OPTIMAL_NROUNDS
#)

#i dont know what measure this is using!
#vip(model_all,num_features=ncol(train0_x))

model_all <- xgboost(data = as.matrix(train0_x), 
                     label = train0_y , 
                     params = PARAMS,
                     nrounds = OPTIMAL_NROUNDS
)
#vip(model_all,num_features=ncol(train0_x))
xgb_fi <- xgb.importance(model=model_all)
xgb.plot.importance(xgb_fi,measure='Gain')

#----------------create predictions for the ensemble fold-----------------------

xgb_ensemble_validation <- encode_type(ensemble_validation)
xgb_ensemble_validation <- polarise(MELBOURNE_CENTRE,xgb_ensemble_validation)
xgb_ensemble_validation_y <- log(xgb_ensemble_validation$price)
xgb_ensemble_validation_x <- xgb_ensemble_validation %>% 
    select(features) %>% as.matrix
xgb_ens_preds <- predict(model_all,newdata = xgb_ensemble_validation_x)

#---------------------------------------------record for tuning-----------------
xgb_cv_error = cv_obj$evaluation_log$test_rmse_mean %>% min
nam <- names(tune_log_xgb)
cv_error <- min(cv_obj$evaluation_log$test_rmse_mean)
tune_log_xgb <- rbind(tune_log_xgb,c((names(for_tune_log_xgb) %in% names(train0_x))*1,xgb_oof_error,xgb_cv_error))
names(tune_log_xgb) <- nam
tune_log_xgb
