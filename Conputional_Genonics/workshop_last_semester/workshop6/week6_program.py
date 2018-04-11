#!/usr/bin/env python

import sys
import numpy

f=open(sys.argv[1])
f.readline()
binz = []
sum = 0
for l in f.readlines():
	binz.append(int(l[:-1]) + 1)
	sum += binz[-1]

mean = float(sum)/len(binz)
logbins = []
for b in binz:
	logbins.append(numpy.log2(b/mean))


print logbins[500:550]

def Z(S, i, j):
	n = len(S)
	return (1.0/(j-i)+1.0/(n-j+i))**(-1/2) * ((S[j]-S[i])/(j-i) - (S[n-1] - S[j] + S[i])/(n-j+i))

def cbs(S):
	max = 0
	n = len(S)
	for i in range(n-1):
		for j in range(i+1, n):
			z = Z(bins, i, j)
			if z > max:
				max = z
				maxi = (z,i,j)
	if max > 0:
		return maxi
	else :
		return (0,-1,-1)
	



intervals = [logbins]
c=5
while intervals and c >0:
	c -= 1
	bins = intervals.pop()
	S=[0]
	for b in bins:
		S.append(S[-1]+b)
	m,i,j = cbs(S[1:])
	print len(bins),m, i, j
	print len(intervals)
	if m>=5 or m<=-5:
		intervals.append(bins[j+1:]+bins[:i])
		intervals.append(bins[i:j+1])

