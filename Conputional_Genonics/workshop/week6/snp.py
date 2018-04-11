import pysam
import sys

bamfile = pysam.AlignmentFile(sys.argv[1],'rb')
keys = ['A', 'C', 'G', 'T', 'N']
for pileupcolumn in bamfile.pileup():
    read_count = pileupcolumn.n
    base_dict = {'A':0, 'T':0, 'C':0, 'G':0, 'N':0}
    score_dict = {'A':0, 'T':0, 'C':0, 'G':0, 'N':0}
    prob_dict = {'A':[0,0], 'T':[0,0], 'C':[0,0], 'G':[0,0], 'N':[0,0]}
    for pileupread in pileupcolumn.pileups:
        if not pileupread.is_del and not pileupread.is_refskip:
            #count the observed nucleotides
            base = pileupread.alignment.query_sequence[pileupread.query_position]
            base_dict[base] += 1
            #count the quality scores
            score = pileupread.alignment.query_qualities[pileupread.query_position]
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
                print pileupcolumn.reference_name+'\t'+str(pileupcolumn.pos)+'\t'+key+'\t'+str(prob_dict[key][0])+'\t'+str(prob_dict[key][1])

