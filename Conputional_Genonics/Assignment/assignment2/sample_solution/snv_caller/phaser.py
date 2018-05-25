from __future__ import division
import pysam
import itertools
import csv

def phaser(bam_filename,vcf_file,outfile):
  bamfile = pysam.AlignmentFile(bam_filename, "rb")
  heterozygote_positions_with_called_bases = _heterozygote_positions_with_called_bases(vcf_file)
  haplotypes_with_concensus_scores = _find_possible_haplotypes_and_concensus_scores(bamfile,heterozygote_positions_with_called_bases)
  concensus_haplotypes,rejected_haplotypes = _haplotype_consensus(haplotypes_with_concensus_scores)
  extended_haplotypes = _extend_haplotypes(concensus_haplotypes)
  _print_findings(outfile,concensus_haplotypes,rejected_haplotypes,extended_haplotypes)
          
def _heterozygote_positions_with_called_bases(variant_file):
  returned_positions = []
  for row in csv.DictReader(variant_file,delimiter='\t'):
    known_base_indices = _known_base_indices(row['SAMPLE'])
    if len(known_base_indices) > 1:
      known_bases = _known_bases(row['REF'],row['ALT'],known_base_indices)
      returned_positions.append({'position': int(row['POS']),'known_bases': known_bases})
  return returned_positions

def _known_bases(ref,alt,known_base_indices):
  all_bases = [ref]+alt.split(',')
  return map(lambda x: all_bases[int(x)],known_base_indices)

def _known_base_indices(sample):
  known_base_indices = {}
  for genotype in sample.split(','):
    for base_index in genotype.split('/'):
      known_base_indices[base_index]=True
  return known_base_indices.keys()
  
def _find_possible_haplotypes_and_concensus_scores(bamfile,heterozygote_positions_and_known_bases):
  haplotypes_with_concensus_scores = []
  last_variant = None
  for variant_row in heterozygote_positions_and_known_bases:
    if last_variant is None:
      last_variant = variant_row
    else:
      haplotypes = {}
      #TODO: FIND PAIRED END READ INFO
      for read in bamfile.fetch('chr15',last_variant['position'],variant_row['position']):
        aligned_positions = read.get_reference_positions()
        if last_variant['position'] in aligned_positions and variant_row['position'] in aligned_positions:
          aligned_position_pairs = read.get_aligned_pairs(matches_only=True,with_seq=True)
          read_pos_at_last_ref_position = [x for x in aligned_position_pairs if x[1] == last_variant['position']][0][0]
          read_pos_at_this_ref_position = [x for x in aligned_position_pairs if x[1] == variant_row['position']][0][0]
          base_at_last_position = read.seq[read_pos_at_last_ref_position].upper()
          base_at_this_pos = read.seq[read_pos_at_this_ref_position].upper()
          if base_at_last_position in last_variant['known_bases'] and base_at_this_pos in variant_row['known_bases']:
            if base_at_last_position is not None and base_at_this_pos is not None:
              haplotype = '{}{}'.format(base_at_last_position,base_at_this_pos)
              if haplotype not in haplotypes:
                haplotypes[haplotype] = 0
              haplotypes[haplotype]+=1
      scored_haplotypes = []  
      totals = _totals_by_starting_base(haplotypes)
      for haplotype, count in haplotypes.iteritems():
        total_for_same_allele_reads = totals[haplotype[0]]
        scored_haplotypes.append((haplotype,count/total_for_same_allele_reads))
      haplotypes_with_concensus_scores.append({'positions':[str(last_variant['position']),str(variant_row['position'])],'haplotypes_with_scores':scored_haplotypes})
    last_variant = variant_row
  return haplotypes_with_concensus_scores

def _totals_by_starting_base(haplotype_counts):
  totals = {}
  for haplotype, count in haplotype_counts.iteritems():
    starting_base = haplotype[0]
    if starting_base not in totals:
      totals[starting_base] = 0
    totals[starting_base] += count
  return totals

def _haplotype_consensus(haplotypes_with_concensus_scores):
  rejected_haplotypes = []
  concensus_haplotypes = []
  for haplotype_dict in haplotypes_with_concensus_scores:
    for haplotype,score in haplotype_dict['haplotypes_with_scores']:
      haplotype = {'positions':haplotype_dict['positions'],'haplotype': haplotype, 'score': score}
      if score >= 0.9:
        concensus_haplotypes.append(haplotype)
      else:
        rejected_haplotypes.append(haplotype)
  return (concensus_haplotypes,rejected_haplotypes)

def _print_findings(outfile,concensus_haplotypes,rejected_haplotypes,extended_haplotypes):
  outfile.write('# Metrics\n')
  outfile.write("Total Haplotypes Considered: {}\n".format(len(concensus_haplotypes)+len(rejected_haplotypes)))
  outfile.write("Total Two-Base Haplotypes Accepted: {}\n".format(len(concensus_haplotypes)))
  outfile.write("Total Two-Base Haplotypes Rejected: {}\n".format(len(rejected_haplotypes)))
  outfile.write("Total Extended Haplotypes: {}\n".format(len(extended_haplotypes)))

  outfile.write('\n\n# Phased Haplotypes\n')
  for concensus_haplotype in concensus_haplotypes:
    pos = ','.join(concensus_haplotype['positions'])
    hap = concensus_haplotype['haplotype']
    score = concensus_haplotype['score']
    outfile.write('Positions: {pos}\tHaplotype: {hap}\tConsensusScore: {score}\n'.format(pos=pos,hap=hap,score=score))    
  outfile.write('\n\n# Not Phased Haplotypes\n')
  for rejected_haplotype in rejected_haplotypes:
    pos = ','.join(rejected_haplotype['positions'])
    hap = rejected_haplotype['haplotype']
    score = rejected_haplotype['score']
    outfile.write('Positions: {pos}\tHaplotype: {hap}\tConsensusScore: {score}\n'.format(pos=pos,hap=hap,score=score))    
  outfile.write('\n\n# Extended Haplotypes\n')
  for extended_haplotype in extended_haplotypes:
    pos = ','.join(extended_haplotype['positions'])
    hap = extended_haplotype['haplotype']
    outfile.write('Positions: {pos}\tHaplotype: {hap}\n'.format(pos=pos,hap=hap))

def _extend_haplotypes(concensus_haplotypes):
  haplotype_outcomes = []

  grouped_by_starting_positions = {}
  for haplotype in concensus_haplotypes:
    starting_position = haplotype['positions'][0]
    if starting_position not in grouped_by_starting_positions:
      grouped_by_starting_positions[starting_position] = []
    grouped_by_starting_positions[starting_position].append(haplotype)

  grouped_by_ending_position_and_end_base = {}
  for haplotype in concensus_haplotypes:
    ending_position = haplotype['positions'][-1]
    if ending_position not in grouped_by_ending_position_and_end_base:
      grouped_by_ending_position_and_end_base[ending_position] = {}
    end_base = haplotype['haplotype'][-1]
    if end_base not in grouped_by_ending_position_and_end_base[ending_position]:
      grouped_by_ending_position_and_end_base[ending_position][end_base] = []
    grouped_by_ending_position_and_end_base[ending_position][end_base].append(haplotype)
  
  last_haplotype = None
  consumed_haplotypes = []
  for haplotype_dict in concensus_haplotypes:
    if haplotype_dict not in consumed_haplotypes:
      extended_haplotype, newly_consumed_haplotypes = _recursively_extend(haplotype_dict,grouped_by_starting_positions,grouped_by_ending_position_and_end_base)
      consumed_haplotypes+=newly_consumed_haplotypes
      haplotype_outcomes.append(extended_haplotype)
  return haplotype_outcomes


def _recursively_extend(haplotype_dict,grouped_by_starting_positions,grouped_by_ending_position_and_end_base,consumed_haplotypes=[]):
  end_position = haplotype_dict['positions'][-1]
  end_base = haplotype_dict['haplotype'][-1]
  if len(grouped_by_ending_position_and_end_base[end_position][end_base]) > 1 or end_position not in grouped_by_starting_positions:
    #then there is contention on the haplotypes and we cannot reliably extend
    # or there is nowhere to extend to
    return (haplotype_dict,consumed_haplotypes)
  else:
    possible_matches = grouped_by_starting_positions[end_position]
    for match_dict in possible_matches:
      match_starting_base = match_dict['haplotype'][0]
      if match_starting_base == end_base:
        return _recursively_extend(_merge_haplotypes(haplotype_dict,match_dict),grouped_by_starting_positions,grouped_by_ending_position_and_end_base,consumed_haplotypes+[match_dict])
      else:
        return (haplotype_dict,consumed_haplotypes)


def _merge_haplotypes(left_haplotype,right_haplotype):
  positions = left_haplotype['positions']+right_haplotype['positions'][1:]
  haplotype = left_haplotype['haplotype']+right_haplotype['haplotype'][1:]
  merged_haplotype = {'positions':positions,'haplotype':haplotype}
  return merged_haplotype
