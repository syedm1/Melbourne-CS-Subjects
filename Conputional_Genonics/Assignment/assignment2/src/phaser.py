#!usr/lib/python2.7
# Auther    : Haonan Li <haonanl5@student.unimelb.edu.au>
# Porpuse   : phasing all nearest positions detected from VCF

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
        if line[9][0] == '0': 
            snps.append(line)
    vcf_f.close()

    # phase all closest varients
    bam_f = pysam.AlignmentFile(bam_file,'rb')
    for i in range(len(snps)-2):
        pos1 = int(snps[i][1])
        pos2 = int(snps[i+1][1])
        bases1 = (snps[i][3], snps[i][4])
        bases2 = (snps[i+1][3], snps[i+1][4])
        haplo, rej_haplo = phase_2var(pos1, pos2, bases1, bases2, bam_f)
        if len(haplo) != 0:
            haplotypes.append(((pos1, pos2), haplo))
        if len(rej_haplo) != 0:
            rej_haplotypes.append(((pos1, pos2), rej_haplo))
    bam_f.close()

    display(haplotypes, rej_haplotypes)


# phase two close variants
def phase_2var(pos1, pos2, bases1, bases2, bam_f):
    # save phase info. key: haplotypes, value: (counts, consensus)
    varients = dict()
    
    # fetch reads fit for phasing
    r1 = bam_f.fetch("chr15", pos1, pos1+1)
    rn1 = set([read.query_name for read in r1])
    r2 = bam_f.fetch("chr15", pos2, pos2+1)
    rn2 = set([read.query_name for read in r2])
    # build a dictionary for query
    d2 = dict()
    for read in bam_f.fetch("chr15", pos2, pos2+1):
        d2[read.query_name] = read
    # name intersection is the reads fit for phasing
    fit_reads = rn1.intersection(rn2)
    
    # phasing
    for read1 in bam_f.fetch("chr15", pos1, pos1+1):
        if read1.query_name not in fit_reads:
            continue
        read2 = d2[read1.query_name]
        start1 = read1.pos
        start2 = read2.pos
        quality1 = list(read1.query_qualities[:])
        quality2 = list(read2.query_qualities[:])
        # first process cigar
        sequence1, quality = parse_cigar(read1.seq, read1.cigar, quality1)
        sequence2, quality = parse_cigar(read2.seq, read2.cigar, quality2)
        '''
        # another method, can get aligned sequence directly and do not need cigar.
        sequence1 = read1.get_reference_sequence()
        sequence2 = read1.get_reference_sequence()
        '''
        # get two bases
        base1 = sequence1[pos1-start1-1]
        base2 = sequence2[pos2-start2-1]
        
        # filter '_', generate from parse_cigar
        if base1 == '_' or base2 == '_':
            continue
        
        # filter quality less than 20
        # if quality[pos1-start1-1]<20 or quality[pos2-start2-1]<20:
        #     continue
        
        # filter obvious wrong aligned read
        if base1 not in bases1 or base2 not in bases2:
            continue
        
        # count haplotypes
        haplo = base1 + base2
        if varients.has_key(haplo):
            varients[haplo][0] += 1
        else:
            varients[haplo] = [1, 0.0]
    return compute_consensus(varients)


def compute_consensus(varients):
    # compute consensus
    for var in varients.keys():
        n_con = 0
        for tmp in varients.keys():
            if tmp[0] == var[0]:
                n_con += varients[tmp][0]
        # keep two decimal digits for display
        varients[var][1] = round(varients[var][0]/float(n_con),2)
    # judge haplotypes
    haplo = []
    rej_haplo = []
    for var in varients.keys():
        if varients[var][1] >= 0.9:
            haplo.append(var)
            haplo.append(varients[var][1])
        else:
            rej_haplo.append(var)
            rej_haplo.append(varients[var][1])
    if len(haplo) < 4:
        rej_haplo += haplo
        haplo = []
    else:
        rej_haplo = []
    return haplo, rej_haplo


# process cigar, process quality score at the same time
def parse_cigar(read, cigar, quality):
    # pos: current process position 
    pos = 0
    for tup in cigar:
        if tup[0] == 0:                     # match
            pos += tup[1]
        elif tup[0] == 1:                   # insertion
            read = read[:pos] + read[(pos+tup[1]):]
            quality = quality[:pos] + quality[(pos+tup[1]):]
        elif tup[0] == 2:                   # deletion
            rep = ''
            rep2 = []
            for i in range(tup[1]):
                rep += '_'
                rep2 += '0'
            read = read[0:pos] + rep + read[pos:]
            quality = quality[0:pos] + rep2 + quality[pos:]
            pos += tup[1]
        elif tup[0] == 4:                   # soft_skip
            read = read[:pos] + read[(pos+tup[1]):]
            quality = quality[:pos] + quality[(pos+tup[1]):]
        else:
            print 'Cigar Warning !!!!!!'
    return read, quality


# display the results 
def display(haplos, rej_haplos):
    n_haplo = 0
    n_reject = 0
    haplos = format_(haplos)
    print ('%-50s %s'%('positions', 'haplotypes'))
    for haplo in haplos:
        n_haplo += 1
        print ('%-50s %s, %s'%(haplo[0], haplo[1], haplo[2]))
    print '\n\n'
    print ('%-29s %s'%('positions','rejected haplotypes'))
    for haplo in rej_haplos:
        n_reject += 1
        print ('%d-%-20d'%(haplo[0][0], haplo[0][1])),
        for i in range (0,len(haplo[1])/2-1):
            print haplo[1][2*i] + ', ',
        print haplo[1][-2]
    print '\n\n\n'
    print 'Number of detected haplotypes: ' + str(n_haplo)
    print 'Number of rejected haplotypes: ' + str(n_reject)


# build haplotypes of more than 2 variants
def format_(haplos):
    new_haplos = []
    i = 0
    while (i<len(haplos)):
        pos = str(haplos[i][0][0]) + '-' + str(haplos[i][0][1])
        hp1 = haplos[i][1][0]
        hp2 = haplos[i][1][2]
        j = i+1
        while (j<len(haplos)):
            if haplos[j][0][0] == haplos[j-1][0][1]:
                pos = pos + '-' + str(haplos[j][0][1])
                hp3 = haplos[j][1][0]
                hp4 = haplos[j][1][2]
            else:
                break
            if hp1[-1] == hp3[0]:
                hp1 += hp3[-1]
                hp2 += hp4[-1]
            else:
                hp1 += hp4[-1]
                hp2 += hp3[-1]
            j += 1
        i = j
        new_haplos.append((pos, hp1, hp2))
    return new_haplos


# Usage of the tool
def usage():
   print ("usage:python phaser.py [options] ... [-b bamfile | -v vcffile] ...")
   print ("Options and arguments:")
   print ("-h     :Help")
   print ("-b     :Sample bam file.")
   print ("-v     :Vcf file.")


def main(argv):
    try:
        opts, args = getopt.getopt(argv[1:], "hb:v:", \
        ["bam=", "vcf="])
    except getopt.GetoptError:
        usage()
        sys.exit(2)
    for opt, arg in opts:
        if opt in ('-h', '--help'):
            usage()
            sys.exit()
        elif opt in ('-b', '--bam='):
            bam_file = arg
        elif opt in ('-v', '--vcf='):
            vcf_file = arg
    
    # Make sure the parameters were defined
    if not('bam_file' in locals().keys()) or \
       not('vcf_file' in locals().keys()):
        usage()
        sys.exit()
       
    # main process
    phase(bam_file, vcf_file)


if __name__ == "__main__":
    main(sys.argv)

