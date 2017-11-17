import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import statsmodels.formula.api as smf


# --- data load and visualization ---
data = pd.read_csv("Advertising.csv")
data = data.iloc[:, 1:] # data.drop(labels = 'Unnamed: 0', axis = 1, inplace = True)

sns.pairplot(data = data)
plt.show()

# --- modeling ---
model = smf.ols(formula='sales ~ TV + radio + newspaper', data = data)
result = model.fit()

