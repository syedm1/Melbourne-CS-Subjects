#!usr/lib/python2.7
# Auther    : Haonan Li <haonanl5@student.unimelb.edu.au>
# Porpuse   : Darw the distribution of quality score for all reads and 
#             mismatches separately.

import os
import sys
from numpy import *
import getopt
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt


# Reverse a read
def reverse(read):
    reverse_read = ""
    read = read[::-1]   #reverse the read
    # get comlimentary read
    for i in range(len(read)):
        if read[i] == 'A':
            reverse_read += 'T'
        elif read[i] == 'T':
            reverse_read += 'A'
        elif read[i] == 'G':
            reverse_read += 'C'
        elif read[i] == 'C':
            reverse_read += 'G'
    return reverse_read


# Compute hamming distance less than min_dis
def hamming_dis(a, b, min_dis):
    dis = 0
    mis_set = set()
    for i in range(len(a)):
        if a[i] != b[i]:
            mis_set.add(i)
            dis += 1
        if dis > min_dis:
            return dis, mis_set
    return dis, mis_set


# Read two files
def init(ref_file, read_file):
    # Reference
    ref_f = open(ref_file, "r")
    line = ref_f.readline()
    ref = ">"
    for line in ref_f.readlines():
        line = line.strip()
        ref += line
    ref = ref.upper()
    # Read file
    read_f = open(read_file, "r")
    reads = []
    line = read_f.readline()
    while line:
        read_name = line.strip()[1:]
        read = read_f.readline().strip()
        read_f.readline()
        read_quality = read_f.readline().strip()
        reads.append((read_name, read, read_quality))
        line = read_f.readline()
    return (ref, reads)


# Aligner 
def alignment(ref, reads):
    # read is tuple of (read_name, read_sequence, quality)
    # all reads
    reads_mis = []
    for read in reads:
        min_dis = 9999
        min_pos = 9999
        mis_set = set()
        # forward search
        # all positions
        for start in range(len(ref)-len(read[1])):
            end = start + len(read[1])
            dis, mis = hamming_dis(read[1], ref[start:end], min_dis)
            if dis < min_dis:
                min_dis = dis
                mis_set = mis
                min_pos = start
        
        # reverse search
        if reverse(read[1]) != read[1]:
            ref = reverse(ref)
            # all positions
            for start in range(len(ref)-len(read[1])):
                end = start + len(read[1])
                dis, mis = hamming_dis(read[1], ref[start:end], min_dis)
                if (dis < min_dis) or (dis == min_dis and start < min_pos):
                    min_dis = dis
                    mis_set = mis
                    min_pos = start
        
        reads_mis.append((read[0],read[1],read[2],mis_set)) 
        
    return reads_mis

# Plot distribution of base quality score
def plot_base_qs(reads, out_qs):
    qs = []
    rlen = {}
    for read in reads:
        score = []
        for ch in read[2]:
            score.append(ord(ch)-ord('!'))
        qs.append(score)
    plt.boxplot([list(i) for i in zip(*qs)])
    plt.show()
    plt.savefig(out_qs)


# Plot distribution of quality score of all mismatches 
def plot_mis_qs(reads_mis, out_qs):
    scores = [[] for i in range(101)]
    for read in reads_mis:
        for pos in read[3]:
            scores[pos].append(ord(read[2][pos])-ord('!'))
    # print msc
    plt.boxplot(scores)
    plt.show()
    plt.savefig(out_qs)


# Usage of the tool
def usage():
   print ("usage:python naive_aligner.py [options] ... [-f reffile | -r readfile | ... ]")
   print ("Options and arguments:")
   print ("-h     :Help")
   print ("-f     :Reference file.")
   print ("-r     :FASTQ read file.")
   print ("-o     :Output path for pictures.")


def main(argv):
    try:
        opts, args = getopt.getopt(argv[1:], "hf:r:o:", \
        ["help", "reference=", "read="])
    except getopt.GetoptError:
        usage()
        sys.exit(2)
    for opt, arg in opts:
        if opt in ('-h', '--help+'):
            usage()
            sys.exit()
        elif opt in ('-f', '--reference+'):
            ref_file = arg
        elif opt in ('-r', '--read='):
            read_file = arg
        elif opt in ('-o','--output='):
            out_path = arg
    # If two essential variables has been defined
    if not('ref_file' in locals().keys()) or not('read_file' in locals().keys()):
        usage()
        sys.exit()
       
    # main process
    out_base_qs = out_path + "/base_qs.png"
    out_mis_qs = out_path + "/mis_qs.png"
    ref, reads = init(ref_file, read_file)
    reads_mis = alignment(ref, reads)
    # plot
    plot_base_qs(reads, out_base_qs)
    plot_mis_qs(reads_mis, out_mis_qs)

if __name__ == "__main__":
    main(sys.argv)
