#!usr/local/bin/python2.7
# Name Haonan Li
# Student ID: 955022

import sys
import os


def analysis():
    mis_f = open("../data/misspell.txt", 'r')
    dic_f = open("../data/dictionary.txt", 'r')
    cor_f = open("../data/correct.txt", 'r')
    res_f = open("../result/dataset_analysis", 'w')

    # read dictionary
    dic = set()
    num_dic = 0
    for line in dic_f.readlines():
        line = line.strip()
        dic.add(line)
        num_dic += 1
    dic_f.close()

    # misspell set
    num_mis = 0
    mis_in_dic = set()
    for line in mis_f.readlines():
        line = line.strip()
        num_mis += 1
        if line in dic:
            mis_in_dic.add(num_mis)
    mis_f.close()

    # correct set
    num_cor = 0
    cor_not_in_dic = set()
    for line in cor_f.readlines():
        line = line.strip()
        num_cor += 1
        if line not in dic:
            cor_not_in_dic.add(num_cor)
    cor_f.close()


    res_f.write("Dictionary size = " + str(num_dic) + '\n')
    res_f.write("Testset size = " + str(num_mis) + '\n')
    res_f.write("Number of misspell words in Dict = " + str(len(mis_in_dic)) + '\n')
    res_f.write("Number of correct words not in Dict = " + str(len(cor_not_in_dic)) + '\n')
    res_f.write("Number of items mis in Dict and cor not in Dict = " + str(len(mis_in_dic.intersection(cor_not_in_dic))) + '\n')
    res_f.write("Number of items mis in Dict or cor not in Dict = " + str(len(mis_in_dic.union(cor_not_in_dic))) + '\n')
    
    res_f.write("\nLine number set of misspell words in Dict\n")
    for item in mis_in_dic:
       res_f.write(str(item) + '\t')
    res_f.write('\n\n')
    res_f.write("Line number set of correct words not in Dict\n")
    for item in cor_not_in_dic:
       res_f.write(str(item) + '\t')
    res_f.write('\n\n')
    
    res_f.close()






def main():
    analysis()

if __name__ == "__main__":
    main()
