#!usr/lib/python2.7
# Auther    : Haonan Li <haonanl5@student.unimelb.edu.au>
# Porpuse   : Generate a VCF file from bam file and reference

import getopt
import pysam
import sys

def read_ref(ref_file):
    ref_file = open(ref_file, "r")
    ref_title = ref_file.readline()
    ref_title = ref_title[1:].strip().split(':')
    ref_name = ref_title[0]
    start_pos = ref_title[1].split('-')[0]
    end_pos = ref_title[1].split('-')[1]
    ref = ""
    for line in ref_file.readlines():
        line = line.strip()
        ref += line
    ref = ref.upper()
    ref_file.close()
    return ref_name, int(start_pos), int(end_pos), ref

def snv_caller(ref_file, bam_file, out_file):
    
    ref_name, start_pos, end_pos, ref = read_ref(ref_file)
    out_f = open(out_file, 'w')
    out_f.write('#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\tSAMPLE\n')

    bam_f = pysam.AlignmentFile(bam_file,'rb')
    keys = ['A', 'C', 'G', 'T', 'N']
    for pileupcolumn in bam_f.pileup():
        # only consider positions in the range of reference 
        if pileupcolumn.pos+1 < end_pos and pileupcolumn.pos+1 >= start_pos:
            ref_key = ref[pileupcolumn.pos+1-start_pos]
        else:
            continue
        read_count = 0
        base_dict = {'A':0, 'T':0, 'C':0, 'G':0, 'N':0}
        score_dict = {'A':0, 'T':0, 'C':0, 'G':0, 'N':0}
        prob_dict = {'A':[0,0], 'T':[0,0], 'C':[0,0], 'G':[0,0], 'N':[0,0]}
        for pileupread in pileupcolumn.pileups:
            if not pileupread.is_del and not pileupread.is_refskip:
                score = pileupread.alignment.query_qualities[pileupread.query_position]
                if score >= 20:  
                    read_count += 1
                    #count the observed nucleotides
                    base = pileupread.alignment.query_sequence[pileupread.query_position]
                    base_dict[base] += 1
                    #count the quality scores
                    score_dict[base] += score

        # get info of bases that different with ref and 
        # present frequency of 20% or higher
        keyy = ''
        score_keyy = 0
        base_keyy = 0
        af = 0.0
        gt = '0'
        ngt = 0
        for key in keys:
            if key != ref_key and base_dict.get(key) > 0:
                prob = float(base_dict.get(key))/read_count
                af += prob
                if prob >= 0.2:
                    keyy = keyy + key + ','
                    score_keyy += score_dict[key]
                    base_keyy += base_dict[key]
                    # genotype, frequency larger than 0.8 treat as heterozygous
                    if prob >= 0.8:
                        gt = '1/1'
                    else:
                        ngt += 1
                        gt += '/'+str(ngt)

        # write VCF file
        if keyy != '':
            quality = score_keyy/float(base_keyy)
            out_f.write (
                ref_name[3:] + '\t'                         \
                + str(pileupcolumn.pos+1) + '\t'            \
                + '.' + '\t'                                \
                + ref_key + '\t'                            \
                + keyy[:len(keyy)-1] + '\t'                 \
                + str(quality) + '\t'                       \
                + 'PASS' + '\t'                             \
                + 'AF=' + str(af) + '\t'                    \
                + 'GT' + '\t'                               \
                + gt + '\n')
    out_f.close()
        
# Usage of the tool
def usage():
   print ("usage:python indexer.py [options] ... [-r reffile | -b bamfile] ...")
   print ("Options and arguments:")
   print ("-h     :Help")
   print ("-r     :Reference file.")
   print ("-b     :Sample bam file.")
   print ("-o     :Output index file.")


def main(argv):
    try:
        opts, args = getopt.getopt(argv[1:], "hr:b:o:", \
        ["reference=", "bam=", "output="])
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
        elif opt in ('-o','--output='):
            out_file = arg
    
    # Make sure the parameters were defined
    if not('ref_file' in locals().keys()) or \
       not('bam_file' in locals().keys()) or \
       not('out_file' in locals().keys()):
        usage()
        sys.exit()
       
    # main process
    read_ref(ref_file)
    snv_caller(ref_file, bam_file, out_file)


if __name__ == "__main__":
    main(sys.argv)

