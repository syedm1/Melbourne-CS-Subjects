#!/usr/bin/env python

import argparse
import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__)),'..')))
from snv_caller.caller import call_snvs
from snv_caller.caller_strategies import HeterozygoteStrategy


parser = argparse.ArgumentParser(description='Given a bam file, report heterozygotes along with probability stats.\nIf not given a reference genome only heterozygotes are detected')
parser.add_argument('bam', type=argparse.FileType('r'),
                    help='a bam file')
parser.add_argument('--outfile', type=argparse.FileType('w'), default=open('snvs.txt', 'w'),
                    help='the called snvs ( Default snvs.txt )')
parser.add_argument('--quality_filter', type=int, default=20,
                    help='only includes bases with a Phred quality score above this number. 0 disables filter ( Default 20 )')

args = parser.parse_args()
caller_strategy = HeterozygoteStrategy()

call_snvs(bam_filename=args.bam.name,caller_strategy=caller_strategy,outfile=args.outfile, quality_filter=args.quality_filter)