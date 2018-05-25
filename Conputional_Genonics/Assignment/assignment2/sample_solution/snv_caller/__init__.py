import pysam

from functools import reduce

def snv_caller(bam_filename, outfile,quality_filter=0):
  bamfile = pysam.AlignmentFile(bam_filename, "rb")
  for pileupcolumn in bamfile.pileup():
    base_probs = _base_probabilities(pileupcolumn,quality_filter)
    filtered_bases = _heterogeneous_bases(base_probs)
    if len(filtered_bases.keys()) >= 2:
      for base, stats in filtered_bases.iteritems():
        outfile.write(_format_vcf(pileupcolumn.reference_name,str(pileupcolumn.pos),base,stats['prob'],stats['avg']))

def _format_vcf(reference, pos, base,prob,avg):
  return "{reference}\t{pos}\t{base}\t{prob}\t{avg}\n".format(reference=reference,pos=pos,base=base,prob=prob,avg=avg)

def _heterogeneous_bases(base_probs):
  return dict((base,probs)for base, probs in base_probs.iteritems() if probs['prob'] >= 0.2 and probs['prob'] <= 0.8)

def _base_probabilities(pileupcolumn, quality_filter):
  base_counts = {}
  base_scores = {}
  read_count = pileupcolumn.n
  for pileupread in pileupcolumn.pileups:
    if not pileupread.is_del and not pileupread.is_refskip:
      base = pileupread.alignment.query_sequence[pileupread.query_position]
      score = pileupread.alignment.query_qualities[pileupread.query_position]
      if quality_filter == 0 or score >= quality_filter:
        if base not in base_counts:
          base_counts[base] = 0
          base_scores[base] = 0
        base_counts[base] += 1
        base_scores[base] += score
  base_probabilities = {}
  for base,base_count in base_counts.items():
    base_count = float(base_count) 
    base_score = float(base_scores[base])
    prob = base_count/read_count
    base_probabilities[base] = {'prob': prob, 'avg': base_score/base_count}
  return base_probabilities

      






