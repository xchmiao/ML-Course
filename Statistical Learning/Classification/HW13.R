library(MASS)
library(ISLR)
library(class)

#attach(Boston)
crim01 = ifelse(crim > mean(crim01), 1, 0)
data = scale(Boston)
data = subset(data.frame(data[, -1], crim01), select = -chas)

set.seed(201)
train_labs = sample(1:nrow(Boston), 400)
train = data[train_labs, ]; test = data[-train_labs, ]
ytrain = crim01[train_labs]; ytest = crim01[-train_labs]

formula = "crim01 ~ zn + nox + dis + indus + rad + age + tax + black + lstat"
glm.fit = glm(formula, train, family = binomial)
glm.probs = predict(glm.fit, test, type = "response")
glm.pred = ifelse(glm.probs > 0.5, 1, 0)
err = mean(glm.pred != ytest)
sprintf("The test error rate from logistic regression is: %.3f", err)

lda.fit = lda(crim01 ~ zn + nox + dis + indus + rad + age + tax + black + lstat, 
              data = train)
lda.pred = predict(lda.fit, test)$class
err = mean(lda.pred != ytest)
sprintf("The test error rate from LDA is: %.3f", err)

qda.fit = qda(crim01 ~ zn + nox + dis + indus + rad + age + tax + black + lstat, 
              data = train)
qda.pred = predict(qda.fit, test)$class
err = mean(qda.pred != ytest)
sprintf("The test error rate from QDA is: %.3f", err)

train = subset(train[, -13], select = c(zn, indus, nox, age, dis, rad, tax, 
                                        black, lstat))
test = subset(test[, -13], select = c(zn, indus, nox, age, dis, rad, tax, 
                                       black, lstat))

err = NULL
ks = 1:20
for (knum in ks){
    set.seed(70)
    knn.pred = knn(train, test, ytrain, knum)
    err = c(err, mean(knn.pred != ytest))
}
best_k = ks[which.min(err)]
sprintf("The lowest test error in KNN is %.3f with k = %d", min(err), best_k)
plot(ks, err, xlab = "k", ylab = "Test Error", type = "o", col = "navy")
