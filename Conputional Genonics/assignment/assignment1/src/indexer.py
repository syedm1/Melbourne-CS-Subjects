#!usr/lib/python2.7
# Auther:       Haonan Li
# E-mail:       haonanl5@student.unimelb.edu.au
# Student-ID:   955022

import os
import sys
import getopt

# Read the FASTA reference, build a k-mer dictionary with positions
def get_kmer_dict(ref_file, k):
    # Read reference information
    ref_file = open(ref_file, "r")
    ref_name = ref_file.readline()
    ref_name = ref_name[1:].strip()
    ref = ">"
    for line in ref_file.readlines():
        line = line.strip()
        ref += line
    ref = ref.upper()
    
    # Build the dictionary, (key: Value) is k-mer and position list separately.
    ref_dict = {}
    for i in range (1,len(ref)-k+1):
        k_mer = ref[i:i+k]
        if k_mer in ref_dict:
            ref_dict[k_mer].append(i)
        else:
            ref_dict[k_mer] = [i]
    return (ref_name, ref_dict)


# Sort the dictionary and output
def build_index(out_file, ref_name, ref_dict, k):
    out_file = open(out_file, "w")
    out_file.write("INDEX:" + ref_name + ' ' + str(k) + '\n')
    ref_tuple = sorted(ref_dict.items(), key = lambda e:e[0], reverse = False)
    for tup in ref_tuple:
        out_file.write(tup[0])
        for pos in tup[1]:
            out_file.write(' ' + str(pos))
        out_file.write('\n')


# Usage of the tool
def usage():
   print ("usage:python indexer.py [options] ... [-f inputfile | -k value] ...")
   print ("Options and arguments:")
   print ("-h     :help")
   print ("-f     :inputfile, absolute or relevant path of the reference file")
   print ("-k     :inputvalue, the number k of k-mers.")


def main(argv):
    try:
        opts, args = getopt.getopt(argv[1:], "hf:k:", ["inputfile=inputk="])
    except getopt.GetoptError:
        usage()
        sys.exit(2)
    for opt, arg in opts:
        if opt in ('-h', '--help'):
            usage()
            sys.exit()
        elif opt in ('-f', '--inputfile'):
            ref_file = arg
        elif opt in ('-k', '--inputk'):
            k = int(arg)
    # If two essential variables has been defined
    if not('ref_file' in locals().keys()) or not('k' in locals().keys()):
        usage()
        sys.exit()
       
    out_file = os.path.dirname(ref_file) + '/index.txt'
    # main process
    ref_name, ref_dict = get_kmer_dict(ref_file, k)
    build_index(out_file, ref_name, ref_dict, k)


if __name__ == "__main__":
    main(sys.argv)
