#!usr/lib/python2.7
# Auther:       Haonan Li
# E-mail:       haonanl5@student.unimelb.edu.au
# Student-ID:   955022

import os
import sys
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


# Compute hamming distance less than mis_dis
def hamming_dis(a, b, min_dis):
    dis = 0
    mis_set = set()
    for i in range(len(a)):
        if a[i] != b[i]:
            mis_set.add(i)
            dis += 1
        if dis > mis_dis:
            return dis, min_set
    return dis, min_set

# Read two files
def init(ref_file, read_file):
    
    # Reference
    ref_f = open(ref_file, "r")
    line = ref_f.readline()
    line = line.strip()
    ref_name = line[1:]
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
        read_name = line.strip()
        read = read_f.readline().strip()
        read_f.readline()
        read_quality = read_f.readline().strip()
        reads.append((read_name, read, read_quality))
        line = read_f.readline()
    return (ref_name, ref, reads)


# Aligner 
def alignment(ref_file, read_file, out_file):
    ref_name, ref, reads = init(ref_file, read_file)
    plot_qs(reads, "../data/quality_score.png")
    '''
    out_f = open(out_file, "w")
    out_f.write("READ_NEME\tREF_NAME\tPOS\tSTRAND\tNUMBER_OF_ALIGNMENTS\tHAMMING_DISTANCE\n")
    
    # read is tuple of (read_name, read_sequence, quality)
    # all reads
    for read in reads:
        min_dis = 2
        min_set = set()
        # forward search
        # all positions
        for start in range(len(ref)-len(read[1])):
            end = start + len(read[1])
            dis = hamming_dis(read[1], ref[start:end])
            if dis < min_dis:
                min_dis = dis
                min_set.clear()
                min_set.add(start)
            elif dis == min_dis:
                min_set.add(start)
        # reverse search
        if reverse(read[1]) != read[1]:
            r_read = reverse(read[1])
            # all positions
            for start in range(len(ref)-len(read[1])):
                end = start + len(read[1])
                dis = hamming_dis(r_read, ref[start:end])
                if dis < min_dis:
                    min_dis = dis
                    min_set.clear()
                    min_set.add(0-start)
                elif dis == min_dis:
                    min_set.add(0-start)
        # output 
        out_f.write(read[0] + '\t' + ref_name + '\t' )
        strand = '-'
        min_pos = 9999
        if len(min_set) == 0:
            out_f.write("0\t*\t*\t*\n")
        else:
            for pos in min_set:
                if abs(pos)<min_pos:
                    min_pos = abs(pos)
                    if pos > 0:
                        strand = '+'
                    elif pos < 0:
                        strand = '-'
            out_f.write(str(min_pos) + '\t' + strand + '\t' + str(len(min_set)) + '\t' + str(min_dis) + '\n')
    '''

def plot_qs(reads, out_qs):
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
        

# Usage of the tool
def usage():
   print ("usage:python naive_aligner.py [options] ... [-f reffile | -r readfile] ...")
   print ("Options and arguments:")
   print ("-h     :help")
   print ("-f     :referencefile, reference file.")
   print ("-r     :readfile, a FASTQ read file.")


def main(argv):
    try:
        opts, args = getopt.getopt(argv[1:], "hf:r:", ["help","reference=","read="])
    except getopt.GetoptError:
        usage()
        sys.exit(2)
    for opt, arg in opts:
        if opt in ('-h', '--help'):
            usage()
            sys.exit()
        elif opt in ('-f', '--reference'):
            ref_file = arg
        elif opt in ('-r', '--read'):
            read_file = arg
    # If two essential variables has been defined
    if not('ref_file' in locals().keys()) or not('read_file' in locals().keys()):
        usage()
        sys.exit()
       
    out_file = "../data/naive_alignment.txt"
    # main process
    alignment(ref_file, read_file, out_file)

if __name__ == "__main__":
    main(sys.argv)
