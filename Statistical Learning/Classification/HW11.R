library(MASS)
library(ISLR)
library(class)

#attach(Auto)
mpg01 = ifelse(mpg > median(mpg), 1, 0)
data = scale(Auto[, -9])
data = subset(data.frame(data, mpg01), select = -mpg)
#data = subset(data, select = c(weight, acceleration, year, origin, mpg01))

set.seed(1)
train_labs = sample(1:nrow(data), 250)
train = data[train_labs, -8]; test = data[-train_labs, -8]
ytrain = mpg01[train_labs]; ytest = mpg01[-train_labs]

ks = 1:10
err_test = NULL
err_train = NULL
for (k_num in ks){
    set.seed(1)
    knn.pred = knn(train, test, ytrain, k = k_num)
    err_test = c(err_test, mean(knn.pred != ytest))
    knn.pred = knn(train, train, ytrain, k = k_num)
    err_train = c(err_train, mean(knn.pred != ytrain))
}
par(mfrow = c(2, 1))
plot(ks, err_train, xlab = "k", ylab = "Training Error", col = "red", type = "o")
plot(ks, err_test, xlab = "k", ylab = "Testing Error", col = "blue", type = "o")