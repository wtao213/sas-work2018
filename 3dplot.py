# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
import numpy  as np
import pandas as pd

#the one doesn't work
data = np.loadtxt(r"C:\Users\wtao\Desktop\AC_CON2.csv", delimiter=',', skiprows=2)

# the one works
data = pd.read_csv(r"C:\Users\wtao\Desktop\neilson_different_channels.csv")

print(data)


x = pd.Series.tolist(data.PLANNED)
y = pd.Series.tolist(data.AUTOPILOT)
z = pd.Series.tolist(data.Price_Consider)

print(x,y,z)

# actual plotting
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

Axes3D.scatter(x, y, z, zdir='z', s=20, c=None,depthshade=True)



#sample for geting a plot
#testing just changes x,y,z value
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

x = pd.Series.tolist(data.PLANNED)
y = pd.Series.tolist(data.AUTOPILOT)
z = pd.Series.tolist(data.Price_Consider)


ax.scatter(x, y, z, c='r', marker='o')

ax.set_xlabel('PLANNED')
ax.set_ylabel('AUTOPILOT')
ax.set_zlabel('Price_Consider')

plt.show()

