#!usr/lib/python2.7
# Auther    : Haonan Li <haonanl5@student.unimelb.edu.au>
# Porpuse   : Visualization of speed of index-alignment 

import matplotlib.pyplot as plt

num_k = ['0', '4', '8', '16', '32']
x = range(len(num_k))
y1 = [24, 18, 1.7, 1.4, 1]
y2 = [50, 35, 1.8, 1.4, 1]
y3 = [80, 52, 1.9, 1.4, 1]
plt.plot(x, y1, marker='o', mec='r', mfc='w',label='ref1')
plt.plot(x, y2, marker='*', ms=10, label='ref2')
plt.plot(x, y3, marker='+', ms=10, label='ref3')
plt.legend()
plt.xticks(x, num_k, rotation=45)
plt.margins(0)
plt.subplots_adjust(bottom=0.15)
plt.xlabel("Length of indexed k-mer") 
plt.ylabel("Time(s)") 

plt.show()
