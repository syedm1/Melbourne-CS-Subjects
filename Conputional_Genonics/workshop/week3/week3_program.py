#!/usr/bin/env python
import pysam 
complement = {'A': 'T', 'C': 'G', 'G': 'C', 'T': 'A'}
 
def reverse_complement(seq):
    #returns reversed sequence of the give sequence 'seq'
    reverse_seq = "".join(complement.get(base,base) for base in reversed(seq)) 
    return reverse_seq

def overlap(r1, r2):
    # if overlap length equals read length -1, returns True
    if r1[1:] == r2[:-1]:
        return True
    else:
        return False

#put all the sequences in a list called 'reads' 
reads = []
f = pysam.FastxFile('reads.fa')
for read in f:
    reads.append(read.sequence)

#An alternative solution to read in FASTA file without pysam:
#skip = True
#for line in open('reads.fa'):
#    if not skip:
#        reads.append(line[:-1])
#    skip = not skip
# 
print 'number of reads: ' + str(len(reads))
 
counts = {4 : {}, 5 : {}}
for k in [4,5]:
  for r in reads:
    for kmer in [r[i:i+k] for i in range(len(reads)-k+1)]:
      if kmer not in counts[k]:
        counts[k][kmer] = 1
      else:
        counts[k][kmer] += 1
      rc = reverse_complement(kmer)
      if rc not in counts[k]:
        counts[k][rc] = 1
      else:
        counts[k][rc] += 1

for k in [4,5]:
  hist = [0]*20
  for c in counts[k].values():
    c = min(len(hist) -1, c)
    hist[c] += 1
  print "hist for when k equals " + str(k) +':'
  print hist


overlaps = {}
for i in range(len(reads)):
    r1 = reads[i]
    for j in range(len(reads)):
        r2 = reads[j]
        if overlap(r1,r2) or overlap(r1, reverse_complement(r2)):
            if i not in overlaps:
                 overlaps[i] = [(i,j)]
            else:
                 overlaps[i].append((i,j))
 
print "overlapping read pairs:" 
for i in overlaps:
  print overlaps[i]

