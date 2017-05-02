library(MASS)
library(ISLR)
library(tree)
library(randomForest)

set.seed(1)
train_lab = sample(1:nrow(Carseats), 2*nrow(Carseats) %/% 3)
train = Carseats[train_lab, ]
test = Carseats[-train_lab, ]
ytest = test$Sales

reg = tree(Sales~., data = train)
plot(reg)
text(reg, pretty = 0, cex = 0.5, col = 2)
ypred = predict(reg, test)
err = mean((ytest - ypred)^2)
sprintf ("The test error is %.2f.", err)

cv.prune = cv.tree(reg, FUN = prune.tree, K = 5)
best_size = cv.prune$size[which.min(cv.prune$dev)]
reg_prune = prune.tree(reg, best = best_size)
ypred = predict(reg_prune, test)
err = mean((ytest - ypred)^2)
sprintf ("After pruning, the test error is %.2f.", err)

set.seed(1)
bag = randomForest(Sales~., data = train, mtry = 10, ntree = 1000,
                   importantce = TRUE)
ypred = predict(bag, test)
err = mean((ytest - ypred)^2)
#err
sprintf ("In the bagging model, the test error is %.2f.", err)
importance(bag)

set.seed(1)
rft = randomForest(Sales~., data = train, mtry = 6, importantce = TRUE, ntree = 1000)
ypred = predict(rft, test)
err = mean((ytest - ypred)^2)
#err
sprintf("In the random forest model, the test error is %.2f.", err)
importance(rft)

mtries = seq(1, ncol(Carseats)-1)
errs = NULL
for (m in mtries){
    set.seed(1)
    rft = randomForest(Sales~., data = train, mtry = m, importance = FALSE, ntree = 1000)
    ypred = predict(rft, test)
    errs = c(errs, mean((ytest - ypred)^2))
}
errs

plot(mtries, errs, type = "o", col = 4, xlab = "Number of Selected Features", 
     ylab = "Test Error") 
title ("Selected Feature Impact in Random Forest")
