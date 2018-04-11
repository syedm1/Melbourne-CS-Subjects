#!/usr/bin/env python

import pysam
import sys
import numpy

base2int={"A":0, "C":1, "G":2, "T":3, "N":4}
samfile = pysam.AlignmentFile(sys.argv[1], "rb")

#strand = {0:[0,0,0,0,0],q:[0,0,0,0,0]}

for pileupcolumn in samfile.pileup():
 	counts = [0,0,0,0,0]
	for pileupread in pileupcolumn.pileups:
		if not pileupread.is_del and not pileupread.is_refskip:
			base = base2int[pileupread.alignment.query_sequence[pileupread.query_position]]
			counts[base] += 1
	percentile = numpy.max([int(numpy.sum(counts) * 0.2), 1]) 
	bases_present = numpy.sum(map(lambda x: x>=percentile, counts))
	if bases_present > 1:
		print pileupcolumn.reference_name, pileupcolumn.pos, counts, percentile
	


samfile.close()
