#!usr/lib/python2.7
# Auther    : Haonan Li <haonanl5@student.unimelb.edu.au>
# Porpuse   : Build a k-mer index for a FASTA reference file

import getopt
import pysam
import sys

def phase(bam_file):
    bam_f = pysam.AlignmentFile(bam_file,'rb')
    for read in bam_f.fetch('chr15', 28356359, 28366118):
        print read
        
# Usage of the tool
def usage():
   print ("usage:python phaser.py [options] ... [-r reffile | -b bamfile] ...")
   print ("Options and arguments:")
   print ("-h     :Help")
   print ("-r     :Reference file.")
   print ("-b     :Sample bam file.")
   print ("-v     :Vcf file.")
   print ("-o     :Output index file.")


def main(argv):
    try:
        opts, args = getopt.getopt(argv[1:], "hr:b:v:o:", \
        ["reference=", "bam=", "vcf=", "output="])
    except getopt.GetoptError:
        usage()
        sys.exit(2)
    for opt, arg in opts:
        if opt in ('-h', '--help'):
            usage()
            sys.exit()
        elif opt in ('-r', '--reference='):
            ref_file = arg
        elif opt in ('-b', '--bam='):
            bam_file = arg
        elif opt in ('-v', '--vcf='):
            bam_file = arg
        elif opt in ('-o','--output='):
            out_file = arg
    
    # Make sure the parameters were defined
    if not('ref_file' in locals().keys()) or \
       not('bam_file' in locals().keys()) or \
       not('vcf_file' in locals().keys()):
        usage()
        sys.exit()
       
    # main process
    phase(bam_file)


if __name__ == "__main__":
    main(sys.argv)

