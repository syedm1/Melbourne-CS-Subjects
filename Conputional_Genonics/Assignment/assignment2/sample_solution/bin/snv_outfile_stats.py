#!/usr/bin/env python

import argparse
import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__)),'..')))
from snv_caller.stats import snv_stats


parser = argparse.ArgumentParser(description='Given a file output from the snv program, prints stats and graphs a scatter plot')
parser.add_argument('stats_file', type=argparse.FileType('r'),
                    help='an output file of the snv binary')
parser.add_argument('--outfile', type=argparse.FileType('w'), default=sys.stdout,
                    help='the file to write the scatterplot out to ( Default STDOUT )')

args = parser.parse_args()
snv_stats(stats_file=args.stats_file, outfile=args.outfile)