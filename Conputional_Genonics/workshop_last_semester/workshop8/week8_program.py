#!/usr/bin/env python
 
import pysam
import numpy
import sys
import matplotlib.pyplot as plt
 
samfile = pysam.AlignmentFile(sys.argv[1], 'rb')
print samfile.references
 
#TASK1 and 2
c = 0
for read in samfile.fetch():
        c+=1
        if c > 10:
                break
        print read
 
#TASK3
c = 0
sizes = []
for read in samfile.fetch():
        c+=1
        if c > 10000:
                break
        if read.is_proper_pair and read.template_length> 0:
                sizes.append(read.template_length)

mean = numpy.mean(sizes)
print mean
std = numpy.std(sizes)
print std

plt.hist(sizes, bins='auto')  
plt.title("Read lengths" )
plt.show()
 
#TASK4
total = 0
anomalous = 0
 
for read in samfile.fetch():
        if read.template_length > 0:
                total +=1
                if read.template_length < mean -(2*std) or read.template_length > mean + (2*std):
                        anomalous += 1
 
print float(anomalous)/total
