#!usr/lib/python2.7
# Auther    : Haonan Li <haonanl5@student.unimelb.edu.au>
# Porpuse   : Build a k-mer index for a FASTA reference file

import getopt
import pysam
import sys

def snv_caller(bam_file, out_file):
    bam_f = pysam.AlignmentFile(bam_file,'rb')
    out_f = open(out_file, 'w')
    keys = ['A', 'C', 'G', 'T', 'N']
    for pileupcolumn in bam_f.pileup():
        read_count = 0
        base_dict = {'A':0, 'T':0, 'C':0, 'G':0, 'N':0}
        score_dict = {'A':0, 'T':0, 'C':0, 'G':0, 'N':0}
        prob_dict = {'A':[0,0], 'T':[0,0], 'C':[0,0], 'G':[0,0], 'N':[0,0]}
        for pileupread in pileupcolumn.pileups:
            if not pileupread.is_del and not pileupread.is_refskip:
                score = pileupread.alignment.query_qualities[pileupread.query_position]
                if score > 19:  
                    read_count += 1
                    #count the observed nucleotides
                    base = pileupread.alignment.query_sequence[pileupread.query_position]
                    base_dict[base] += 1
                    #count the quality scores
                    score_dict[base] += score

        base_count = 0
        for key in keys:
            if base_dict.get(key) > 0:
                prob = float(base_dict.get(key))/read_count
                if prob >= 0.2 and prob <= 0.8:
                    prob_dict[key][0] = prob
                    prob_dict[key][1] = score_dict[key]/float(base_dict[key])
                    base_count += 1
                    #print base_count, pileupcolumn.pos, prob_dict

        if base_count >= 2:
            for key in keys:
                if prob_dict[key][0] > 0:
                    out_f.write (pileupcolumn.reference_name + '\t'    \
                    + str(pileupcolumn.pos) + '\t'              \
                    + key + '\t'                                \
                    + str(prob_dict[key][0]) + '\t'             \
                    + str(prob_dict[key][1]) + '\t'             \
                    + str(read_count) + '\n')
    out_f.close()

# Usage of the tool
def usage():
   print ("usage:python indexer.py [options] ... [-b bamfile] ...")
   print ("Options and arguments:")
   print ("-h     :Help")
   print ("-b     :Sample bam file.")
   print ("-o     :Output index file.")


def main(argv):
    try:
        opts, args = getopt.getopt(argv[1:], "hb:o:", \
        ["bam=", "output="])
    except getopt.GetoptError:
        usage()
        sys.exit(2)
    for opt, arg in opts:
        if opt in ('-h', '--help'):
            usage()
            sys.exit()
        elif opt in ('-b', '--bam='):
            bam_file = arg
        elif opt in ('-o','--output='):
            out_file = arg
    
    # Make sure the parameters were defined
    if not('bam_file' in locals().keys()) or \
       not('out_file' in locals().keys()):
        usage()
        sys.exit()
       
    # main process
    snv_caller(bam_file, out_file)


if __name__ == "__main__":
    main(sys.argv)


