#!usr/lib/python2.7
# Auther    : Haonan Li <haonanl5@student.unimelb.edu.au>
# Porpuse   : Visualization of speed of index-alignment 

import matplotlib.pyplot as plt

num_k = ['1', '2', '3', '4']
x = range(len(num_k))
y1 = [2.56, 10.19, 10.43, 10.38]
y2 = [25.56, 21.09, 20.81, 20.67]
plt.plot(x, y1, marker='o', mec='r', mfc='w',label='ref1')
plt.plot(x, y2, marker='*', ms=10, label='ref2')
plt.legend()
plt.xticks(x, num_k, rotation=45)
plt.margins(0)
plt.subplots_adjust(bottom=0.15)
plt.xlabel("N") 
plt.ylabel("") 

plt.show()
