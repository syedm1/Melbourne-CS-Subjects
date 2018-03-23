#!usr/lib/python2.7
# Auther:       Haonan Li
# E-mail:       haonanl5@student.unimelb.edu.au
# Student-ID:   955022

import os
import sys
import getopt

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


# Compute hamming distance less than 3
def hamming_dis(a,b):
    dis = 0
    for i in range(len(a)):
        if a[i] != b[i]:
            dis += 1
        # treat read with distance larger than 2 not aligned
        if dis > 2:
            return dis
    return dis

# Read three files
def init(index_file, ref_file, read_file):
    # Index file
    index_f = open(index_file, "r")
    line = index_f.readline()
    K = line.strip().split()[1]
    K = int(K)
    ref_index = {}
    for line in index_f.readlines():
        line = line.strip()
        line = line.split()
        ref_index[line[0]] = line[1:]
    
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
    return (K, ref_index, ref_name, ref, reads)


# Aligner 
def alignment(index_file, ref_file, read_file, out_file):
    K, ref_index, ref_name, ref, reads = init(index_file, ref_file, read_file)
    out_f = open(out_file, "w")
    out_f.write("READ_NEME\tREF_NAME\tPOS\tSTRAND\tNUMBER_OF_ALIGNMENTS\tHAMMING_DISTANCE\n")
    
    # read is tuple of (read_name, read_sequence, quality)
    # all reads
    for read in reads:
        min_dis = 2
        min_set = set()
        # forward search
        # all k_mers
        for read_pos in range(len(read[1])-K+1):
            k_mer = read[1][read_pos:(read_pos+K)]
            if k_mer in ref_index:
                # all positions
                for ref_pos in ref_index[k_mer]:
                    ref_pos = int(ref_pos)
                    start = ref_pos-read_pos
                    end = ref_pos+len(read[1])-read_pos
                    if start>0 and end<=len(ref):
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
            # all k_mers
            for read_pos in range(len(r_read)-K+1):
                k_mer = r_read[read_pos:(read_pos+K)]
                if k_mer in ref_index:
                    # all positions
                    for ref_pos in ref_index[k_mer]:
                        ref_pos = int(ref_pos)
                        start = ref_pos-read_pos
                        end = ref_pos+len(r_read)-read_pos
                        if start>0 and end<=len(ref):
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
        
        

# Usage of the tool
def usage():
   print ("usage:python indexer.py [options] ... [-i indexfile | -f reffile | -r readfile] ...")
   print ("Options and arguments:")
   print ("-h     :help")
   print ("-i     :indexfile, reference index file")
   print ("-f     :referencefile, reference file.")
   print ("-r     :readfile, a FASTQ read file.")


def main(argv):
    try:
        opts, args = getopt.getopt(argv[1:], "hi:f:r:", ["help","index=","reference=","read="])
    except getopt.GetoptError:
        usage()
        sys.exit(2)
    for opt, arg in opts:
        if opt in ('-h', '--help'):
            usage()
            sys.exit()
        elif opt in ('-i', '--index'):
            index_file = arg
        elif opt in ('-f', '--reference'):
            ref_file = arg
        elif opt in ('-r', '--read'):
            read_file = arg
    # If two essential variables has been defined
    if not('index_file' in locals().keys()) or \
        not('ref_file' in locals().keys()) or \
        not('read_file' in locals().keys()):
        usage()
        sys.exit()
       
    out_file = "../data/alignment.txt"
    # main process
    alignment(index_file, ref_file, read_file, out_file)

if __name__ == "__main__":
    main(sys.argv)
