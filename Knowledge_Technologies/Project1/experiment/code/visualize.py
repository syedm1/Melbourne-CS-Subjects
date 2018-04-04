#!usr/lib/python2.7
# Auther    : Haonan Li <haonanl5@student.unimelb.edu.au>

import matplotlib.pyplot as plt
import numpy as np

scale_ls = range(7)  
index_ls = ['Soundex','N-Gram','LEG','GED','Editex']  
plt.xticks(scale_ls, index_ls)

a = plt.subplot(1, 1, 1)

x = [10, 20, 30, 40, 50]
x1 = [7, 17, 27, 37, 47]


Y1 = [0.1, 0.3, 8, 10, 8]
Y2 = [61, 18, 28, 21, 32]


plt.bar(x1, Y1, facecolor='red', width=3, label = 'Recall')
plt.bar(x, Y2, facecolor='blue', width=3, label = 'Precision')

plt.legend()

plt.show()
