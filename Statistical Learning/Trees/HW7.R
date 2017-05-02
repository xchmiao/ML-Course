library(MASS)
library(ISLR)
library(randomForest)
library(ggplot2)
set.seed(1)
train = sample(1:nrow(Boston), 2*nrow(Boston) %/% 3)
test = Boston[-train, ]
ytest = Boston[-train, "medv"]
result = NULL
trees = seq(1, 1001, by = 50)
mtries = c(1, 3, 6, 9, 13)
for (m in mtries){
    err = NULL
    for (n in trees){
        rf = randomForest(medv~., data = Boston, subset = train, mtry = m, ntree = n)
        ypred = predict(rf, newdata = test)
        err = c(err, mean((ytest - ypred)^2))
    }
    result = cbind(result, err)
}
result = data.frame(result)
colnames(result) = c("m1", "m3", "m6", "m9", "m13")

plt <- ggplot(result, aes(x = trees)) + geom_line(aes(y = m1, color = "m = 1")) +
    geom_line(aes(y = m3, color = "m = 3")) + geom_line(aes(y = m6, color = "m = 6")) + 
    geom_line(aes(y = m13, color = "m = 13")) + geom_line(aes(y = m9, color = "m = 9")) +
    labs(x = "Number of Trees", y = "MSE", color = "Selected Features", 
         title = "Random Forest Fitting")

plt