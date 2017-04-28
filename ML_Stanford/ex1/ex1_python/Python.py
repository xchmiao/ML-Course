import os 
import numpy as np
import matplotlib.pyplot as plt

def plotData(x, y): # plot the ogrinal data
    plt.plot(x, y, 'ro')
    plt.xlim(0, 25)
    plt.show()

def gradDes(X, y, theta, alpha, num_iters):
	m = len(y)
	J_history = np.array([])
	for i in range(num_iters):
		delta = np.dot(X,theta) - y
		J = np.dot(delta.T, delta)/(2*m)
		# print np.shape(J), np.shape(delta)
		theta = theta - (alpha/m)* np.dot(X.T, delta)
		J_history = np.append(J_history, J)
		if (i == 0):
			print "The cost function starts from %.2f." % J
	
	return theta, J_history
	

path = r"C:\Users\21010\Desktop\test\ML1\ex1"
os.chdir(path)
datafile = "ex1data1.txt"

print "Read and plot the orginal data from %s file." % datafile

data = np.loadtxt(datafile, delimiter = ",") # load data into numpy array

#---------------------- Part1: Plot data -----------------------
x = data[:, :-1]
y = data[:, -1]
plotData(x, y)

#---------------------- Part2: Gradient Descent ----------------
print "Runing gradient descent ... "
m = len(y)
X = np.insert(x, 0, 1, axis = 1) # insert all-1 into the first col (axis = 1) of x
y = np.reshape(y, (m, 1))
alpha = 0.01
num_iters = 1500

theta = np.zeros((np.shape(X)[1], 1))

theta, J_his = gradDes(X, y, theta, alpha, num_iters)

x_axis = np.arange(1, len(J_his)+1)
#plt.plot(x_axis, J_his, 'b-', linewidth = 2)
plt.semilogx(x_axis, J_his, 'b-', linewidth = 2)
plt.xlabel('Number of iterations')
plt.ylabel('Cost Function J')
plt.show()

#------------------------ Part3: Put the fitting line in the original data --------------

x_fit = np.arange(1, 25, 0.1)
y_fit = x_fit * theta[1] + theta[0]


plt.plot(x, y, "ro", label = "Original Data")
plt.plot(x_fit, y_fit, "b-", linewidth = 2, label = "Gradient Descent")

z = np.polyfit(x.flatten(), y.flatten(), deg = 1)
p = np.poly1d(z)

plt.plot(x_fit, p(x_fit), "k--", linewidth = 1.0, label = "'PloyFit module'")
plt.legend(loc = 2)
    
plt.show()
