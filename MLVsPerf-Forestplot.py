
import pandas as pd
import numpy as np
import xlrd
from scipy import stats
import arviz as az
import matplotlib.pyplot as plt
import PythonMeta as PMA


data = pd.read_excel("./FPlot_analysis.xlsx", sheet_name=1)

df = pd.DataFrame(data)

algo_col = df["MLAlgo"].drop_duplicates()

mean = []
lower = []
upper = []

dt_dict = []

for algo in algo_col:
    dt = df[df["MLAlgo"] == algo]
    dt_f = dt["Fmeasure"]
# mean
    dt_mean = np.mean(dt_f)
# standard deviation
    dt_std = np.std(dt_f)
# standard error mean
    dt_sem = stats.sem(dt_f)
#  probability density
    dt_pd = stats.t.ppf(.95, dt_mean)
# standard error
    dt_se = dt_sem * dt_pd

    # dt_dict[algo] = [dt_mean/100, (dt_mean + dt_se)/100, (dt_mean - dt_se)/100]

    # l = dt_mean - dt_se
    # u = dt_mean + dt_se


    # lower.append((dt_mean - dt_se)/100)
    # upper.append((dt_mean + dt_se)/100)

    # mean.append(dt_mean/100)

# print([mean, lower, upper])

# dt_dict = {
#   "mean": mean,
#   "lower": lower,
#   "upper": upper
# }


print(dt_dict)

# test = pd.DataFrame(dt_dict)


data_frame=[
  "SVM, 62.11666666666668,72.69401488264567,51.53931845068768,1",
  "DecisionTree, 0.8331703703703703, 0.9029347981632785, 0.7634059425774623,18",
  "NaiveBayes, 0.5650814814814816, 0.6581175662078189, 0.47204539675514423,18",
  " "
]

samp_cate=[  #this array can be stored into a data file by lines, and loaded with d.readfile("filename")
    "SVM 2016,20,40,18,35",
    "Gong 2012,10,40,18,35",
    "Liu 2015,30,50,40,50",
    "Long 2012,19,40,26,40",
    "Wang 2003,7,86,15,86",
    " ",
]
print(data_frame)

d = PMA.Data()  # Load Data class
m = PMA.Meta()  # Load Meta class
f = PMA.Fig()  # Load Fig class

d.datatype = "CATE"

print('a')
test1 = d.getdata(data_frame)

m.datatype = d.datatype
m.models = "Fixed"
m.algorithm = "MH"
m.effect = "RR"

result = m.meta(test1)

f.forest(result).show()

plt.show()

# az.style.use("arviz-darkgrid")

# axes = az.plot_forest(dt_dict, hdi_prob=.95, linewidth=2,
#                       combined=True, figsize=(9, 7))

# axes[0].set_title('F−measure values of machine learning algorithm')
# plt.show()
