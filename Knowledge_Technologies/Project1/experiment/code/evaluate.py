#!usr/local/bin/python2.7
# Name Haonan Li
# Student ID: 955022

import sys
import os

def evaluate(pre_fpath, out_fpath):
    # read predicted file
    pre_f = open(pre_fpath, "r")
    out_f = open(out_fpath, "w")
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
    
    print(pre_fpath + '\t' + str(attempt_res) + '\t' + str(correct_res) + '\n')

    pre_f.close()
    out_f.close()
       
def main():
    for i in range(2,10):
        evaluate("../result/n_gram"+str(i), "../evaluate/n_gram2")

if __name__ == "__main__":
    main()
