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
    max_dis = 0
    for i in range(1, a_len):
        for j in range(1, b_len):
            dp[i][j] = max(0, dp[i-1][j]-1, dp[i][j-1]-1, dp[i-1][j-1]+(1 if a[i-1] == b[j-1] else -1))
            if max_dis < dp[i][j]:
                max_dis = dp[i][j]
    return max_dis

def edit_dis():
    mis_f = open("../data/misspell.txt", 'r')
    dic_f = open("../data/dictionary.txt", 'r')
    res_f = open("../result/local_edit_dis", 'w')

    # read dictionary
    dic = []
    for line in dic_f.readlines():
        line = line.strip()
        dic.append(line)
    dic_f.close()

    # process misspell file
    for line in mis_f.readlines():
        # print (line) # test
        line = line.strip()
        # compute the similarity
        max_dis = 0
        max_set = set()
        for i in range(len(dic)):
            dis = distance(dic[i], line)
            if dis > max_dis:
                max_dis = dis
                max_set.clear()
                max_set.add(i)
            elif dis == max_dis:
                max_set.add(i)
        # print (max_set)   # test
        res_f.write(str(max_dis) + '\t')
        for i in max_set:
            res_f.write(dic[i] + '\t')
        res_f.write('\n')
    mis_f.close()
    res_f.close()

def main():
    edit_dis()
if __name__ == "__main__":
    main()
