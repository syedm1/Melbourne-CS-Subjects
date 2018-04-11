#!/usr/bin/env python
import pysam
import random
BASE="ACGT"

# compute hamming distance equal length strings
def hamming_distance(a, b):
	assert(len(a) == len(b))
	return sum(ch1 != ch2 for ch1, ch2 in zip(a, b))


# simulate read of length 100
random.seed(12345)
rlen=10
read = ''.join(random.choice(BASE) for i in range(rlen))
print "read = ", read

f = pysam.FastaFile('ecoli.fa')
seq = f.fetch("ecoli_MG1655",0)

# find location in ref genome with best alignment
loc = -1
best = rlen 
for i in range(len(seq) - rlen+1): 
	current = hamming_distance(read, seq[i:i+rlen])
	if current < best:
		loc = i
		best = current

print "loc = ", loc, "distance = ", best
