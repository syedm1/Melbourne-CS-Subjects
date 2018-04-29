#!usr/lib/python2.7
# Auther    : Haonan Li <haonanl5@student.unimelb.edu.au>
# Porpuse   : Automatic running task1_basic.py and task1_advanced.py for three samples

import sys
import os
import commands

# Basic SNV caller
# Sample command 'python task1_basic.py ../data/sample1.bam > ../data/task1_basic_sample1'
for i in [1,2,3]:
    cmd = 'python task1_basic.py ../data/sample' + str(i) + '.bam > ../data/task1_basic_sample' + str(i)
    commands.getstatusoutput(cmd)
    
# Advanced SNV caller
# Sample command 'python task1_advanced.py -b ../data/sample1.bam -o ../data/task1_advance_sample1'
for i in [1,2,3]:
    cmd = 'python task1_advanced.py -b ../data/sample' + str(i) + '.bam -o ../data/task1_advanced_sample' + str(i)
    commands.getstatusoutput(cmd)

def analysis(res_file):
    f = open(res_file, 'r')
    quantity = 0
    read_count = 0
    score = 0.0
    for line in f.readlines():
        quantity += 1
        line = line.strip().split()
        read_count += int(line[-1])
        score += int(line[-1]) * float(line[-2])
    quality = score / read_count
    return quantity, quality
    
# Analysis
for i in [1,2,3]:
    basic = '../data/task1_basic_sample' + str(i)
    advanced = '../data/task1_advanced_sample' + str(i)
    b_quantity, b_quality = analysis(basic)
    a_quantity, a_quality = analysis(advanced)
    print 'sample' + str(i) + '\t\tquantity\tquality'
    print 'basic\t\t' + str(b_quantity) + '\t\t' + str(b_quality)
    print 'advanced\t' + str(a_quantity) + '\t\t' + str(a_quality)


