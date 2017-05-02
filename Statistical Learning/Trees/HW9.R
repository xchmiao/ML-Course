library(MASS)
library(ISLR)
library(tree)

set.seed(1)
train_lab = sample(1:nrow(OJ), 800)
train = OJ[train_lab, ]; test = OJ[-train_lab, ]
ytest = test$Purchase

set.seed(3)
oj.tree = tree(Purchase~., data = train)
summary(oj.tree)
plot(oj.tree)
text(oj.tree, pretty = 0, cex = 0.5, col = 4)
#print(oj.tree)
ypred = predict(oj.tree, test, type = "class")
print("The confustion table is:")
tb = table(ypred, ytest)
print(tb)
err = (tb[1, 2] + tb[2, 1])/(length(ypred))
sprintf("The test error rate is: %.2f", err)

set.seed(3)
cvtree = cv.tree(oj.tree, FUN = prune.misclass)
plot(cvtree$size, cvtree$dev, xlab = "Tree Szie", ylab = "Deviance", type = "o", col = 4)
#bestsize = cvtree$size[which.min(cvtree$dev)]
bestsize = 5
set.seed(3)
prune.treecv = prune.misclass(oj.tree, best = bestsize)
plot(prune.treecv)
text(prune.treecv, pretty = 0, cex = 0.5, col = 3)
ypred = predict(prune.treecv, test, type = "class")
tb = table(ypred, ytest)
print (tb)
err.prune = (tb[1, 2] + tb[2, 1])/(length(ypred))
sprintf("The test error of the pruned tree is: %.2f", err.prune)
