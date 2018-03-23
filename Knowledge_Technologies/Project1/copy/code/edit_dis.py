#!usr/local/bin/python2.7
# Name Haonan Li
# Student ID: 955022

import sys
import os

# edit distance
def distance(a, b):
    # init
    a_len = len(a) + 1
    b_len = len(b) + 1
    dp = [[0 for i in range(b_len)] for j in range(a_len)]
    for i in range(a_len):
        dp[i][0] = i
    for i in range(b_len):
        dp[0][i] = i
    # dp
    for i in range(1, a_len):
        for j in range(1, b_len):
            dp[i][j] = min(dp[i-1][j]+1, dp[i][j-1]+1, dp[i-1][j-1]+(0 if a[i-1] == b[j-1] else 1))
    return dp[a_len-1][b_len-1]

def edit_dis()        
    mis_f = open("../data/misspell.txt", 'r')
    dic_f = open("../data/dictionary.txt", 'r')
    res_f = open("../result/edit_dis", 'w')

    # read dictionary
    dic = []
    for line in dic_f.readlines():
        line = line.strip()
        dic.append(line)
    dic_f.close()

    # process misspell file
    for line in mis_f.readlines():
        line = line.strip()
        # compute the similarity
        min_dis = 99
        min_set = set()
        for i in range(len(dic)):
        # for i in range(50):
            dis = distance(dic[i], line)
            if dis < min_dis:
                min_dis = dis
                min_set.clear()
                min_set.add(i)
            elif dis == min_dis:
                min_set.add(i)
        # print min_set
        res_f.write(str(min_dis) + '\t')
        for i in min_set:
            res_f.write(dic[i] + '\t')
        res_f.write('\n')
    mis_f.close()
    res_f.close()

def main():
    edit_dis()
if __name__ == "__main__"
    main()
