import os 
import numpy as np
import matplotlib.pyplot as plt

def featureNorm(array):
	sigma = np.std(array, axis = 0) # calculated the std every col
	mu = np.mean(array, axis = 0)
	array_norm = (array - mu)/sigma
	return array_norm, mu, sigma
	
def GradDes(X, y, theta, alpha, num_iter):
	m = len(y);
	J_hist = np.array([])
	for i in range(num_iter):
		delta = np.dot(X, theta) - y
		J = np.dot(delta.T, delta)/(2*m)
		theta = theta - (alpha/m)*np.dot(X.T, delta)
		J_hist = np.append(J_hist, J)
	
	return theta, J_hist

def NormalEqu(X, y):
	a = np.linalg.inv(np.dot(X.T, X))
	a = np.dot(a, X.T)
	theta = np.dot(a, y)
	return theta

print "Loading data..."
path = r"E:\Course\Machine Learning\machine-learning-ex1\ex1"
os.chdir(path)
datafile = "ex1data2.txt"

data = np.loadtxt(datafile, delimiter = ",")
x = data[:, :-1]
y = data[:, -1]
m = len(y)
y = np.reshape(y, (m, 1))

print "First 10 examples from the dataset:"
print data[:10, :]

#---------------- Feature scaling --------------
x_norm, mu, sigma = featureNorm(x)
X = np.insert(x_norm, 0, 1, axis = 1)

#---------------- Gradient Descent -------------
num_iters = 4000
alpha = 0.01

theta = np.zeros((np.shape(X)[1], 1))

theta, J_history = GradDes(X, y, theta, alpha, num_iters)

print "\nPlot the Cost funciton J vs number of iteration..."
plt.semilogx(np.arange(1, num_iters+1), J_history, 'b-', linewidth = 1.5)
# plt.plot(np.arange(1, num_iters+1), J_history, 'b-', linewidth = 1.5)
plt.xlabel("Number of iterations")
plt.ylabel(r"Cost function J($\theta$)")
plt.show()

print "\nThe optimum theta is found to be the following:"
print theta

#-------------------- Estimate the Price ----------
# what is the house price for a 1650 sq-ft, 3br house

x0 = np.array([1650, 3])
x0_norm = (x0 - mu)/sigma
x0_norm = np.insert(x0_norm, 0, 1)
price = np.dot(x0_norm, theta)

print "The estimated price to by a 1650 sq-ft and 3 br house is $%d\n" % price
#-------------------- Get theta from normal Equation
print '*'*20
print 'Using Normal Equation to find the best fitting...'
theta = NormalEqu(X, y)
price = np.dot(x0_norm, theta)
print "\nThe optimum theta is found to be the following:"
print theta

print "\nThe estimated price to by a 1650 sq-ft and 3 br house is $%d" % price






