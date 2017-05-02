library(gbm)
library(ISLR)

set.seed(0)
data = data.frame(Caravan); data$pch = ifelse(data$Purchase == "No", 0, 1)
train_labels = seq(1:1000)
train = data[train_labels, ]; test = data[-train_labels, ]
ytest = test$pch

set.seed(1)
car.gbm = gbm(pch~.-Purchase, distribution = "bernoulli", data = train, n.trees = 1000, 
              shrinkage = 0.01, verbose = F)
summary(car.gbm)

ypred = predict(car.gbm, newdata = test, n.trees = 1000, type = "response")
ypred = ifelse(ypred > 0.2, 1, 0)
tb = table(ypred, ytest)
print(tb)

fra = tb[2, 2]/(tb[2, 1] + tb[2, 2])
sprintf("The fraction of people predicted to make a purchase 
        actually do is: %.2f", fra)
