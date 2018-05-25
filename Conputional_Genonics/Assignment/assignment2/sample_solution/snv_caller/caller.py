from __future__ import division
import pysam
from functools import reduce
from Bio import SeqIO, Seq

def call_snvs(bam_filename, outfile,caller_strategy,quality_filter=0):
  bamfile = pysam.AlignmentFile(bam_filename, "rb")
  for pileupcolumn in bamfile.pileup():
    base_probs = _base_probabilities(pileupcolumn,quality_filter)
    called_snvs = caller_strategy(pileupcolumn,base_probs)
    formatted = caller_strategy.format_output(pileupcolumn.reference_name, pileupcolumn.pos,called_snvs)
    outfile.write(formatted)

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
    prob = base_count/read_count
    base_probabilities[base] = {'prob': prob, 'avg': base_scores[base]/base_count}
  return base_probabilities
