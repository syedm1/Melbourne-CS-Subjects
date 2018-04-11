#!usr/local/lib/python2.6
import pysam

#read in BAM file, which has reads aligned to chr15:28356263-28366213 (0-based)
bamfile = pysam.AlignmentFile('reads.bam','rb')

start = 28356263
end = 28366213+1
count = [[] for i in range(end-start) ]

#get base information using pileup()
for pileupcolumn in bamfile.pileup():
    bases = []

    # print ('coverage at base %s:%s = %s' %(pileupcolumn.reference_name, pileupcolumn.pos, pileupcolumn.n))
    # now get information on this postion:
    for pileupread in pileupcolumn.pileups:
        if not pileupread.is_del and not pileupread.is_refskip:
            bases.append(pileupread.alignment.query_sequence[pileupread.query_position])
    for i in range(len(bases)):
        count[pileupcolumn.pos - start + i].append(bases[i])    
    # print bases
bamfile.close()

for li in count:
    print li

