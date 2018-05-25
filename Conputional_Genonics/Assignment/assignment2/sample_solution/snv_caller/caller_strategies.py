from Bio import SeqIO, Seq
import re
import itertools

class SubReference():
  def __init__(self,reference_file):
    reference = next(SeqIO.parse(reference_file,'fasta'))
    (self.reference_name,self.min_pos,self.max_pos) = self._parse_label(reference.name)
    self._reference_seq = reference.seq

  def is_valid_pos(self,pos):
    return self.min_pos <= pos < self.max_pos

  def _parse_label(self,label):
    result = re.match('(?P<ref>\w*):(?P<min>\d*)-(?P<max>\d*)', label)
    zero_based_min = int(result.group('min'))-1
    zero_based_max = int(result.group('max'))-1
    return (result.group('ref'),zero_based_min,zero_based_max)

  def __getitem__(self,sliceobj):
    sliced_bases = None
    if isinstance(sliceobj, int):
      sliced_bases= self._reference_seq[sliceobj-self.min_pos]
    elif isinstance(sliceobj, slice):
      new_slice = slice(sliceobj.start-self.min_pos,sliceobj.stop-self.min_pos,sliceobj.step)
      sliced_bases= self._reference_seq[new_slice]
    else:
      raise TypeError
    return sliced_bases.upper()

  def __len__(self):
    return self.max_pos+1
  

class HeterozygoteStrategy():
  def __call__(self,pileupcolumn,base_probs):
    filtered_bases = self._heterogeneous_bases(base_probs)
    if len(filtered_bases.keys()) < 2:
      filtered_bases = {}
    return filtered_bases

  def format_output(self,reference_name, pos, called_snvs):
    output = ''
    for base, stats in called_snvs.iteritems():
      output += self._format(reference_name,str(pos),base,stats['prob'],stats['avg'])
    return output

  def _heterogeneous_bases(self,base_probs):
    return dict((base,probs)for base, probs in base_probs.iteritems() if probs['prob'] >= 0.2 and probs['prob'] <= 0.8)

  def _format(self,reference, pos, base,prob,avg):
    return "{reference}\t{pos}\t{base}\t{prob}\t{avg}\n".format(reference=reference,pos=pos,base=base,prob=prob,avg=avg)


class ReferenceStrategy():
  def __init__(self,reference_obj):
    self.reference = reference_obj
    self._written_header = False

  def __call__(self,pileupcolumn,base_probs, frequency_cutoff=0.2):
    filtered_probs = {}
    reference_pos = pileupcolumn.pos
    if self.reference.is_valid_pos(reference_pos):
      reference_base = self.reference[reference_pos]
      for base,probs in base_probs.iteritems():
        if probs['prob'] >= frequency_cutoff:
          filtered_probs[base]=probs
      if not any(map(lambda base_tuple: base_tuple[0] != reference_base,filtered_probs)):
        filtered_probs = {}
    return filtered_probs

  def format_output(self,reference_name, pos, called_snvs):
    if not any(called_snvs):
      return ''

    output = ''
    if not self._written_header:
      self._written_header = True
      output+= '#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\tSAMPLE\n'

    chrom_num = re.search('\d+',reference_name).group(0)
    ref = self.reference[pos]
    alts = []
    freqs = []
    quals = []
    for base, stats in sorted(called_snvs.iteritems(),key=lambda base_tuple: base_tuple[0]):
      if base != ref:
        alts.append(base)
        freqs.append(stats['prob'])
        quals.append(stats['avg'])
    all_found_bases = called_snvs.keys()
    genotypes = self._format_genotypes(all_found_bases,ref,alts)
    output += self._format(chrom_num,pos,ref,alts,quals,freqs,genotypes)
    return output

  def _format_genotypes(self,all_found_bases,ref,alts):
    positions = []
    for base in all_found_bases:
      if base == ref:
        positions.append(str(0))
      else:
        positions.append(str(alts.index(base)+1))
    if len(positions) == 1:
      return '{}/{}'.format(positions[0],positions[0])
    else:
      return ','.join(map(lambda x: '/'.join(sorted(x)),itertools.combinations(positions,2)))

  def _format(self,chrom_num,pos,ref,alts,quals,freqs,sample,identifier='.',filt='PASS',form='GT'):
    info = 'AF={}'.format(','.join(map(lambda x: str(x),freqs)))
    alt = ','.join(alts)
    return '{chrom_num}\t{pos}\t{id}\t{ref}\t{alt}\t{qual}\t{filter}\t{info}\t{format}\t{sample}\n'\
      .format(chrom_num=chrom_num,pos=pos,id=identifier,ref=ref,alt=alt,qual=quals[0],filter=filt,info=info,format=form,sample=sample)



