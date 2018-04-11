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
time = time[:333]
for i in range (1,334):
    ref_len.append(i*15)

plt.plot(ref_len, time, mec='r', mfc='w')
plt.legend()
plt.margins(0)
plt.subplots_adjust(bottom=0.15)
plt.xlabel("Length of read") 
plt.ylabel("Time(s)") 

plt.show() 

