#!/usr/bin/env python

import argparse
import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__)),'..')))
from snv_caller.phaser import phaser


parser = argparse.ArgumentParser(description='Given a bam file, report heterozygotes along with probability stats.\nIf not given a reference genome only heterozygotes are detected')
parser.add_argument('bam', type=argparse.FileType('r'),
                    help='a bam file')
parser.add_argument('--vcf', type=argparse.FileType('r'),
                    help='the vcf for the given bam file. The output of the snv_reference.py command')
parser.add_argument('--outfile',  type=argparse.FileType('w'), default=sys.stdout,
                    help='metrics on the phased haplotypes ( Default STDOUT )')

args = parser.parse_args()

phaser(bam_filename=args.bam.name,vcf_file=args.vcf,outfile=args.outfile)