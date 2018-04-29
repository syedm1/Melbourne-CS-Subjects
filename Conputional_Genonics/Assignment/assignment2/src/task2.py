#!usr/lib/python2.7
# Auther    : Haonan Li <haonanl5@student.unimelb.edu.au>
# Porpuse   : Automatic running vcf_builder.py for three samples
import sys
import os
import commands

# Build VCF file from a bam file
# Sample command 'python vcf_builder.py -r ../data/reference_human.fa -b ../data/sample1.bam -o ../data/task2_sample1.vcf'
for i in [1,2,3]:
    cmd = 'python vcf_builder.py -r ../data/reference_human.fa -b ../data/sample' + str(i) + '.bam -o ../data/task2_sample' + str(i) + '.vcf'
    commands.getstatusoutput(cmd)
    
