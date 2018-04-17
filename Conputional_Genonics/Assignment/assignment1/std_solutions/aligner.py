#################################################
#
# COMP90016 Computational Genomics
# Assignment 1
#
# File name: aligner.py
#
# Created by: Zequn Ma
#
#################################################

import pysam
import sys

# alignments are saved if hamming distance <= this value
DIST_THRESHOLD = 2

# parse file containing reference k-mer indexes
# returns: k
#		   REF_NAME
#		   index dictionary
def parse_index(index_filename):
	index_file = open(index_filename)
	k = 0 			# length of k-mer, to be read from file
	ref_name = ''	# name of reference, to be read from file
	fl = True 		# flag indicating first line of file
	indexes = {}	# reconstructed k-mer indexes
	for line in index_file:
		elements = line.split()
		if fl:
			ref_name = elements[1]
			k = int(elements[2])
			fl = False
			continue
		k_mer = elements[0]
		indexes[k_mer] = []
		for i in elements[1:]:
			indexes[k_mer].append(int(i))
	return k, ref_name, indexes

# extract k-mers from a read sequence
def extract_k_mers(read, k):
	k_mers = {}
	for i in range(len(read) - k + 1):
		k_mers[read[i:i+k]] = k_mers.get(read[i:i+k], [])
		k_mers[read[i:i+k]].append(i)
	return k_mers

# calculate hamming distance between read and a segement from reference
def hamming_dist(read, segement):
	dist = 0
	# lengths of the two arguements must be equal
	if len(read) != len(segement):
		return DIST_THRESHOLD + 1
	for i in range(len(read)):
		if read[i] == segement[i]: continue
		dist += 1
		# early termination
		if dist > DIST_THRESHOLD: return dist
	return dist

# returns the reverse complement of a sequence
def rev_comp(sequence):
	out = ''
	for char in sequence:
		if char == 'A': out += 'T'
		if char == 'T': out += 'A'
		if char == 'C': out += 'G'
		if char == 'G': out += 'C'
	return out[::-1]

# return potential alignments from matched k-mer
# offset: length of leading characters
# length: length of align
def candidate_aligns(sequence, indexes, offset, length, checked):
	candidates = set()
	new_checked = checked
	for i in indexes:
		s = i - offset
		if s in new_checked: continue
		new_checked.add(s)
		e = s + length
		candidates.add((sequence[s:e], s))
	# candidates: alignments
	return candidates, new_checked

# return alignments with hamming distance less or equal to 2
def possible_aligns(read, candidates):
	aligns = []
	for candidate, index in candidates:
		dist = hamming_dist(read, candidate)
		if dist <= DIST_THRESHOLD:
			aligns.append((dist, index))
	return aligns

# find all alignments of hamming distance less or equal to 2
def find_aligns(read_k_mers, ref_k_mers, read, reference):
	all_aligns = [] # (index, dist)
	checked_indexes = set()
	for k_mer, read_indexes in read_k_mers.items():
		if k_mer not in ref_k_mers: continue
		for i in read_indexes:
			candidates, checked_indexes = candidate_aligns(reference, ref_k_mers[k_mer], i, len(read), checked_indexes)
			possiblities = possible_aligns(read, candidates)
			for element in possiblities:
				all_aligns.append(element)
	return all_aligns

# return the best alignment 
def find_best(aligns):
	if aligns == []: return (DIST_THRESHOLD+1, 0)
	return min(aligns)

if __name__ == '__main__':
	if len(sys.argv) != 4:
		print "Usage:"
		print "\t./aligner.py index_file reference_file reads_file"

	# Parse index file
	try:
		k, ref_name, ref_k_mers = parse_index(sys.argv[1])
	except IOError:
		print "File", sys.argv[1], "does not exist."
		quit()

	# Parse reference sequence
	try:
		reference = [seq.sequence.upper() for seq in pysam.FastxFile(sys.argv[2])][0]
	except:
		print "File", sys.argv[2], "does not exist."
		quit()

	# Parse reads file
	try:
		reads = pysam.FastxFile(sys.argv[3])
	except:
		print "File", sys.argv[3], "does not exist."
		quit()

	# Write to output
	output = open("alignment.txt", 'w')
	output.write("READ_NAME\tREF_NAME\tPOS\tSTRAND\tNUMBER_OF_ALIGNMENTS\tHAMMING_DISTANCE\n")

	for read in reads:
		rev_comp_read = rev_comp(read.sequence)
		for_k_mers = extract_k_mers(read.sequence, k)
		rev_k_mers = extract_k_mers(rev_comp(read.sequence), k)
		pos_aligns = find_aligns(for_k_mers, ref_k_mers, read.sequence, reference)
		neg_aligns = find_aligns(rev_k_mers, ref_k_mers, rev_comp_read, reference)
		pos_best = find_best(pos_aligns)
		neg_best = find_best(neg_aligns)
		pos_aligns = [(d, i) for (d, i) in pos_aligns if d == pos_best[0]]
		neg_aligns = [(d, i) for (d, i) in neg_aligns if d == neg_best[0]]

		# determine strand to repport
		if pos_best[0] > DIST_THRESHOLD and neg_best[0] > DIST_THRESHOLD:
			output.write(read.name + '\t*\t0\t*\t0\t*\n');
			continue
		elif pos_best[0] > DIST_THRESHOLD or pos_best[0] > neg_best[0]: strand = '-'
		elif neg_best[0] > DIST_THRESHOLD or pos_best[0] < neg_best[0]: strand = '+'
		else:
			strand = '+' if pos_best[1] <= neg_best[1] else '-'
		
		# write to file
		pos = pos_best[1] if strand == '+' else neg_best[1]
		if pos_best[0] < neg_best[0]: no_of_alignments = len(pos_aligns)
		elif neg_best[0] < pos_best[0]: no_of_alignments = len(neg_aligns)
		elif neg_best == pos_best: no_of_alignments = len(pos_aligns)
		else: no_of_alignments = len(pos_aligns) + len(neg_aligns)
		hamming = pos_best[0] if strand == '+' else neg_best[0]
		output.write(read.name + '\t' + ref_name + '\t' + str(pos+1) + '\t' + strand + '\t' + str(no_of_alignments) + '\t' + str(hamming) + '\n');

	output.close()

	
