#!usr/lib/python2.7
# Auther    : Haonan Li <haonanl5@student.unimelb.edu.au>
# Porpuse   : Visualization of speed of index-alignment 

import matplotlib.pyplot as plt

f = open("../data/runtime_ref_length")

time = []
ref_len = []
for line in f.readlines():
    t = line.strip()
    time.append(float(t))
for i in range (1,1000):
    ref_len.append( 15002 * i / 1000 )
plt.plot(ref_len, time, marker='o', mec='r', mfc='w',label='ref1')
plt.legend()
plt.margins(0)
plt.subplots_adjust(bottom=0.15)
plt.xlabel("Length of indexed k-mer") 
plt.ylabel("Time(s)") 

plt.show() 

