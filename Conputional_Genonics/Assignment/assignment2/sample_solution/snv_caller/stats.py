from __future__ import division
import matplotlib.pyplot as plt

def snv_stats(stats_file, outfile):
  unique_positions = {}
  total_avg_quality = 0
  total_called_bases = 0

  all_frequencies = []
  all_quality_score_averages = []
  reference = None
  for line in stats_file:
    parsed_line = _parse_line(line)
    pos = parsed_line['pos']
    if pos not in unique_positions:
      unique_positions[pos] = 0
    unique_positions[pos] += 1
    total_avg_quality += parsed_line['avg']
    total_called_bases += 1
    all_frequencies.append(parsed_line['prob'])
    all_quality_score_averages.append(parsed_line['avg'])
    reference = parsed_line['reference']
  outfile.write('Unique heterozygous positions: {}\n'.format(len(unique_positions.keys())))
  outfile.write('Average base quality score: {}\n'.format(total_avg_quality/total_called_bases))
  _show_scatterplot(reference,all_frequencies,all_quality_score_averages)


def _parse_line(line):
  splitted = line.split('\t')
  return {
    'reference':splitted[0],
    'pos':splitted[1],
    'base':splitted[2],
    'prob':float(splitted[3]),
    'avg':float(splitted[4]),
  }

def _show_scatterplot(reference,all_frequencies,all_quality_score_averages):
  dpi=100
  plt.figure(1,figsize=(1400/dpi,600/dpi),dpi=dpi)
  plt.subplot(211)
  unindexed_hamming_dist, = plt.plot(all_frequencies,all_quality_score_averages,'ro', label='Quality vs Frequency of Base Reads')
  plt.legend(handles=[unindexed_hamming_dist])
  plt.ylabel('Avgerage Quality Score')
  plt.xlabel('Frequency')
  plt.show()
