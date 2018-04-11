#!/usr/bin/env python

import matplotlib.pyplot as plt
import pysam

f = pysam.FastxFile('reads.fastq')
qs = []
rlen = {}

for read in f:
	qs.append(read.get_quality_array())
	if len(read.get_quality_array()) in rlen:
		rlen[len(read.get_quality_array())] += 1
  	else:
		rlen[len(read.get_quality_array())] = 1

for len in rlen:
	print len, rlen[len]

plt.boxplot([list(i) for i in zip(*qs)])
plt.show()

