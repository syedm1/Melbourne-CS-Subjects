import pysam

#read in BAM file, which has reads aligned to chr15:28356263-28366213 (0-based)
bamfile = pysam.AlignmentFile('reads.bam','rb')

#get base information using pileup()
for pileupcolumn in bamfile.pileup():
    bases = []
    print ('coverage at base %s:%s = %s' %(pileupcolumn.reference_name, pileupcolumn.pos, pileupcolumn.n))
    #now get information on this postion:
    for pileupread in pileupcolumn.pileups:
        if not pileupread.is_del and not pileupread.is_refskip:
            bases.append(pileupread.alignment.query_sequence[pileupread.query_position])
    print bases
bamfile.close()




