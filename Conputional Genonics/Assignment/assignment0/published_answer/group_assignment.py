#!/usr/bin/env python

from Bio import SeqIO
import sys
import time

before = time.time()
#Support Class to create alignments 
class Alignment:
  def __init__(self, readId, chr, pos, strand, numberOfAlignments):
    self.readId = readId
    self.chr = chr
    self.pos = pos
    self.strand = strand
    self.numberOfAlignments = numberOfAlignments
  #Print the alignment in tab separated format
  def __repr__(self):
    return "\t".join([self.readId, str(self.chr), str(self.pos), str(self.strand), str(self.numberOfAlignments)])

#A class for a perfect match read aligner
class PerfectMatchAligner:

  def __init__(self, ref):
    self.refname = ref.id
    self.refseq = ref.seq
    self.revcompRefseq = ref.seq.reverse_complement()
    self.reflen = len(ref.seq)

  def findString(self, ref, string):
    positions = []
    for i in range(len(ref)-len(string)+1):
      match = True
      for c1, c2 in zip(ref[i:i+len(string)], string):
        if c1 != c2:
          match = False
          break
      if match:
        positions.append(i) 
    return positions
    
  def align(self, read):
    forwardAlignments = self.findString(self.refseq, read)
    reverseAlignments = self.findString(self.revcompRefseq, read)
    numberOfAlignments = len(forwardAlignments) + len(reverseAlignments)
    if numberOfAlignments == 0:
      return Alignment(read.id, "*", 0, "*", 0)
    if len(reverseAlignments) > 0:
      #convert reverse alignments to coordinates relative to reference start
      reverseAlignments = [self.reflen - x - len(read)  for x in reverseAlignments]
    #Identify smallest position in all alignments
    pos = min(forwardAlignments + reverseAlignments) 
    #Identify correct strand
    if pos in forwardAlignments:
      strand = "+"
    else:
      strand = "-"
    #return the first alignment (add 1 to coordinate for 1-based solution)
    return Alignment(read.id, self.refname, pos + 1, strand, numberOfAlignments)
            
#Check the command line arguments
if len(sys.argv) < 3:
  print "Usage: <reference file (fasta)> <read file (fastq)> "
  sys.exit(0)


#Read the reference sequence and initiate the aligner
try:
  for s in SeqIO.parse(sys.argv[1], "fasta"):  
    aligner = PerfectMatchAligner(s)
    break #Stop after the fist sequence in the reference
except IOError as e:
  print "Could not read reference sequence file (see below)!"
  print e
  sys.exit(1)

#Open the read data, output file and get to work   
try:
  output = open('alignment.txt', 'w')
  numberOfAlignments = [0,0,0]
  for read in SeqIO.parse(sys.argv[2], "fasta"):
    alignment = aligner.align(read)
    if alignment.numberOfAlignments == 0 and aligner.align(read[:-1]).numberOfAlignments > 0:
      print "All of this read's bases match, except for the last!"
    numberOfAlignments[ min(2,alignment.numberOfAlignments) ] += 1
    output.write(str(alignment)+"\n")

  output.close()    

  #print summary statistics
  total = sum(numberOfAlignments)
  print "Alignment complete!\nThe summary statistics are:"
  print "Reads aligning 0 times (unmapped): %d (%f%%)" %(numberOfAlignments[0], float(numberOfAlignments[0])/total*100)
  print "Reads aligning 1 time (unique match): %d (%f%%)" %(numberOfAlignments[1], float(numberOfAlignments[1])/total*100)
  print "Reads aligning 2 or more times (multi-mapped): %d (%f%%)" %(numberOfAlignments[2], float(numberOfAlignments[2])/total*100) 


  after = time.time()
  diff = after-before
  print("Execution time is:"+str(diff))
except IOError as e:
  print "Could not read fasta input file (see below)!"
  print e
  sys.exit(1)

