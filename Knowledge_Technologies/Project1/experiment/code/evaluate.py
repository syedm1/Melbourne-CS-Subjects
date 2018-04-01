#!usr/local/bin/python2.7
# Name Haonan Li
# Student ID: 955022

import sys
import os

def evaluate(pre_fpath):
    # read predicted file
    pre_f = open(pre_fpath, "r")
    predict = []
    for line in pre_f.readlines():
        ss = set()
        line = line.strip()
        line = line.split()
        for i in range(1, len(line)):
            ss.add(line[i])
        predict.append(ss)
    
    attempt_res = 0
    for ss in predict:
        attempt_res += len(ss)

    # read correct file and evaluate
    cor_f = open("../data/correct.txt", "r")
    line_num = 0
    correct_res = 0
    for line in cor_f.readlines():
        line = line.strip()
        if line in predict[line_num]:
            correct_res += 1
        line_num += 1

    print(pre_fpath + '\t' + \
        str(attempt_res) + '\t' + \
        str(correct_res) + '\t' + \
        str(float(correct_res)/attempt_res) + '\t' + \
        str(float(correct_res)/716) + '\n'
        )

    cor_f.close()
    pre_f.close()
       
def main():
    root = "../result/"

    for i in os.listdir(root):
        print i
        evaluate(root+i)

if __name__ == "__main__":
    main()
