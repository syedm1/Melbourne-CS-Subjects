#!/usr/bin/env python


import pysam


f = pysam.FastxFile('reads.fastq')

for read in f:
  print "This is the first read in the file:"
  print "The read name is", read.name
  print "The quality string:", read.quality
  print "Which stands for the following Phred values:", read.get_quality_array()
  print "The first base of the read is:", read.sequence[0]
  break
