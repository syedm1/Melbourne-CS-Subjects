#!usr/lib/python2.7
# Auther    : Haonan Li <haonanl5@student.unimelb.edu.au>
# Porpuse   : Build a k-mer index for a FASTA reference file

import getopt
import pysam
import sys


# phase: main part
def phase(bam_file, vcf_file):
    # haplotype format tuple(pos1, pos2, base1, base2)
    haplotypes = []
    rej_haplotypes = []
    # read vcf_files
    vcf_f = open(vcf_file, 'r')
    vcf_f.readline()
    snps = []
    for line in vcf_f.readlines():
        line = line.strip().split()
        snps.append(line)
    vcf_f.close()

    # phase all close varients
    bam_f = pysam.AlignmentFile(bam_file,'rb')
    for i in range(len(snps)-2):
        pos1 = int(snps[i][1])
        pos2 = int(snps[i+1][1])
        haplo, rej_haplo = phase_2var(pos1, pos2, bam_f)
        haplotypes += ((pos1, pos2), haplo)
        rej_haplotypes += ((pos1, pos2), rej_haplo)
    bam_f.close()

    display(haplotypes, rej_haplotypes)


def display(haplos, rej_haplos):
    for haplo in haplos:
        print haplo
    print '\n\n\n\n\n\n'
    for haplo in rej_haplos:
        print haplo


# phase two close variants
def phase_2var(pos1, pos2, bam_f):
    varients = dict()
    for read in bam_f.fetch('chr15', pos1, pos2):
        start = read.pos
        sequence = parse_cigar(read.seq, read.cigar)
        # filter sequencne not contain both of them
        if start + len(sequence) <= pos2 or start > pos1:
            continue
        # filter '_'
        base1 = sequence[pos1-start]
        base2 = sequence[pos2-start]
        if base1 == '_' or base2 == '_':
            continue
        # count 
        couple = (sequence[pos1-start], sequence[pos2-start])
        if varients.has_key(couple):
            varients[couple] += 1
        else:
            varients[couple] = 1
    # consensus
    haplo = []
    rej_haplo = []
    for var in varients.keys():
        n_con = 0
        for tmp in varients.keys():
            if tmp[0] == var[0] or tmp[1] == var[1]:
                n_con += varients[tmp]
        if varients[var]/float(n_con) >= 0.9:
            haplo.append(var)
        else:
            rej_haplo.append(var)
    return haplo, rej_haplo



# solve indel and other cigar problem
def parse_cigar(read, cigar):
    pos = 0
    for tup in cigar:
        if tup[0] == 0:                     # match
            pos += tup[1]
        elif tup[0] == 1:                   # insertion
            read = read[:pos] + read[(pos+tup[1]):]
        elif tup[0] == 2:                   # deletion
            rep = ''
            for i in range(tup[1]):
                rep += '_'
            read = read[0:pos] + rep + read[pos:]
            pos += tup[1]
        elif tup[0] == 3:                   # ref_skip
            print 'waring!!!'
        elif tup[0] == 4:                   # soft_skip
            read = read[:pos] + read[(pos+tup[1]):]
        else:
            print 'warning!!!'
    return read





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
            vcf_file = arg
        elif opt in ('-o','--output='):
            out_file = arg
    
    # Make sure the parameters were defined
    if not('ref_file' in locals().keys()) or \
       not('bam_file' in locals().keys()) or \
       not('vcf_file' in locals().keys()):
        usage()
        sys.exit()
       
    # main process
    phase(bam_file, vcf_file)


if __name__ == "__main__":
    main(sys.argv)

