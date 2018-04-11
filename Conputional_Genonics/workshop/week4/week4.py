#!/usr/bin/env python
#import pysam
from Bio import SeqIO
import sys

#Support class to execute the handiwork of read alignment to a reference sequence
class Aligner1:
  def __init__(self, ref):
    self.refname = ref.id
    self.seq = ref.seq
    self.rseq = ref.seq.reverse_complement()
  def align(self, read):
    alignments = []
    return alignments

# compute hamming distance equal length strings
def hamming_distance(a, b):
    assert(len(a) == len(b))
    return sum(ch1 != ch2 for ch1, ch2 in zip(a, b))

#Check the command line arguments
parameters = sys.argv
argc = len(parameters)
if argc != 4:
  print "Usage: <reference file (fasta)> <read file (fasta)> <max hamming distance>"
  sys.exit(0)

#Read the reference sequence and initiate the aligner
try:
  for s in SeqIO.parse(sys.argv[1], "fasta"):
    ref = Aligner1(s)
    refname = ref.refname
    break #Stop after the first sequence in the reference
except IOError as e:
  print "Could not read reference sequence file (see below)!"
  print e
  sys.exit(1)

try:
    alignment_ham = '*'
    print 'READ_NAME \t REF_NAME \t POS \t STRAND \t NUMBER_OF_ALIGNMENTS \t HAMMING_DISTANCE'
    for r in SeqIO.parse(sys.argv[2],"fasta"):
        hamming = sys.argv[3]
        pos = 0
        count = 0
        best_pos = -1
        read = Aligner1(r)
        #refname = ref.refname
        while pos+len(read.seq)<=len(ref.seq):
            diff1 = hamming_distance(read.seq, ref.seq[pos:pos+len(read.seq)])
            diff2 = hamming_distance(read.rseq, ref.seq[pos:pos+len(read.rseq)])
            diff = min(diff1, diff2)
            if diff <= hamming:
                if diff == hamming and best_pos != -1:
                    pos += 1
                    count += 1
                    continue
                count = 1
                best_pos = pos
                hamming = diff
                if diff == diff1: strand = "+"
                else: strand = "-"
            pos += 1
        alignment_pos = best_pos + 1
        alignment_ham = str(hamming)
        output = read.refname + "\t" + refname + "\t" + str(alignment_pos) + "\t" + str(strand) + "\t" + str(count) + "\t" + alignment_ham
        print output
except IOError as e:
    print 'error!'
    print e
    sys.exit(1)
