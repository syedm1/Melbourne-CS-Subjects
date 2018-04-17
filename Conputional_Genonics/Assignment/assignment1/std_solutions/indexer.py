#################################################
#
# COMP90016 Computational Genomics
# Assignment 1
#
# File name: indexer.py
#
# Created by: Zequn Ma
#
#################################################

import pysam
import sys

if __name__ == '__main__':
	# check number of command line arguements
	if len(sys.argv) != 3:
		print 'Usage:'
		print '\t./indexer.py reference_filename k'
		quit()

	ref_filename = sys.argv[1]
	k = int(sys.argv[2])

	# read reference file
	try:
		ref_file = pysam.FastxFile(ref_filename)
	except IOError:
		print "Specified reference file not found."
		quit()

	# Don't assume single sequence per file
	sequences = [sequence for sequence in ref_file]
	all_index = {}

	for seq in sequences:
		seq_name = seq.name
		# convert all to upper case
		current_seq = seq.sequence.upper()
		k_mers = {}
		for i in range(len(current_seq) - k + 1):
			# length k starting from i
			k_mer = current_seq[i:i+k]
			k_mers[k_mer] = k_mers.get(k_mer, [])
			k_mers[k_mer].append(i)
		all_index[seq_name] = k_mers

	# write in output file "index.txt"
	# indexes start from 0
	index_file = open("index.txt", 'w')
	for seq_name, k_mers in all_index.items():
		index_file.write("INDEX: " + seq_name + ' ' + str(k) + '\n')
		for k_mer, indexes in k_mers.items():
			index_file.write(k_mer + ' ')
			for index in indexes:
				index_file.write(str(index) + ' ')
			index_file.write('\n')

