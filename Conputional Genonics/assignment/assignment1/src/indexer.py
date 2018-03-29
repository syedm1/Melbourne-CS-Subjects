#!usr/lib/python2.7
# Auther    : Haonan Li <haonanl5@student.unimelb.edu.au>
# Porpuse   : Build a k-mer index for a FASTA reference file

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
   print ("usage:python indexer.py [options] ... [-i inputfile | -k value] ...")
   print ("Options and arguments:")
   print ("-h     :help")
   print ("-i     :inputfile, absolute or relevant path of the reference file.")
   print ("-k     :inputvalue, the number k of k-mers.")
   print ("-o     :outputfile, absolute or relevant path of the output file.")


def main(argv):
    try:
        opts, args = getopt.getopt(argv[1:], "hi:k:o:", \
        ["inputfile=", "inputk=", "outputfile="])
    except getopt.GetoptError:
        usage()
        sys.exit(2)
    for opt, arg in opts:
        if opt in ('-h', '--help'):
            usage()
            sys.exit()
        elif opt in ('-i', '--inputfile'):
            ref_file = arg
        elif opt in ('-k', '--inputk'):
            k = int(arg)
        elif opt in ('-o','--outputfile'):
            out_file = arg
    
    # Make sure the parameters were defined
    if not('ref_file' in locals().keys()) or \
       not('k' in locals().keys()) or \
       not('out_file' in locals().keys()):
        usage()
        sys.exit()
       
    # main process
    ref_name, ref_dict = get_kmer_dict(ref_file, k)
    build_index(out_file, ref_name, ref_dict, k)


if __name__ == "__main__":
    main(sys.argv)
