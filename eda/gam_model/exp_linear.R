#run after something else to get train0_x
mod <- lm(train0_y ~ .,data=train0_x)
preds = predict(mod,train0_x)
sqrt(mean((preds - train0_y)^2))
plot(mod)

#
bc=boost_control(mstop=300,nu=0.1)
mod = glmboost(train0_y ~ .,data=train0_x,control = bc)
preds = predict(mod,train0_x)
sqrt(mean((preds-train0_y)^2))
plot(mod)
#

#
#maybe try local linear?
#

#
#maybe try orthogonal polynomials?
#

#linear models with splines?--------------------------------------------
#gam(train0_y ~ . , data=train0_x,family='gaussian',df=100)
#this is addative, perhaps search for interactions and encode them explicitly
mod = train(train0_x,train0_y,method='gamSpline',trControl = trainingParams,tuneGrid=data.frame(df=20:40))

#----boosted
newdf = cbind(train0_x,train0_y)
bc=boost_control(mstop=300,nu=0.1)
#mod = mboost(train0_y ~ .,data=newdf,baselearner = 'bbs')
#mod = gamboost(train0_y ~ .,data=newdf,baselearner = 'bbs',dfbase=2)
preds = predict(mod,train0_x)
sqrt(mean((preds-train0_y)^2))
plot(mod)
#-------------------------------


#

for(var in names(train0_x)) {
    print(var)
    train0_x[[var]] <- train0_x[[var]] - mean(train0_x[[var]])
    train0_x[[var]] <- train0_x[[var]]/sd(train0_x[[var]])
}


ctrl = bst_control(mstop=100,nu=0.05)
mod = bst(train0_x,train0_y,family='huber',learner='ls',ctrl = ctrl)
preds = predict(mod,train0_x)
sqrt(mean((preds-train0_y)^2))
plot(mod)

#trainingParams = trainControl(index=train_folds,
#                              indexOut=folds,
#                              verbose=T)

#mod = train(train0_x,train0_y,method='BstLm',
#            trControl = trainingParams,
#            family='gaussian'
#            )
