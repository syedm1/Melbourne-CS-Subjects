#!usr/local/bin/python2.7
# Name Haonan Li
# Student ID: 955022

import sys
import os

# editex letter distance matrix
ALPHABET = "abcdefghijklmnopqrstuvwxyz#"
letter_group = ["aeiouy", "bp", "ckq", "dt", "lr", "mn", "gj", "fpv", "sxz", "csz"] # 'h' and 'w' are not in the group
# init distance matrix 
D = [[2 for i in range(27)] for j in range(27)]
for i in range(26):
    D[ALPHABET.index('h')][i] = 1
    D[ALPHABET.index('w')][i] = 1
    D[i][ALPHABET.index('h')] = 1
    D[i][ALPHABET.index('w')] = 1
for subgroup in letter_group:
    for i in subgroup:
        for j in subgroup:
            D[ALPHABET.index(i)][ALPHABET.index(j)] = 1
for i in range(27):
    D[i][26] = 1
    D[26][i] = 1
    D[i][i] = 0
# print D


# edit distance
def distance(a, b):
    # init, add '#' for compute convience
    a = '#' + a
    b = '#' + b
    a_len = len(a)
    b_len = len(b)
    dp = [[0 for i in range(b_len)] for j in range(a_len)]
    for i in range(1, a_len):
        dp[i][0] = dp[i-1][0] + D[ALPHABET.index(a[i-1])][ALPHABET.index(a[i])]
    for j in range(1, b_len):
        dp[0][j] = dp[0][j-1] + D[ALPHABET.index(b[j-1])][ALPHABET.index(b[j])]
    # dp
    for i in range(1, a_len):
        for j in range(1, b_len):
            dp[i][j] = min( dp[i-1][j] + D[ALPHABET.index(a[i-1])][ALPHABET.index(a[i])],\
                            dp[i][j-1] + D[ALPHABET.index(b[j-1])][ALPHABET.index(b[j])],\
                            dp[i-1][j-1] + D[ALPHABET.index(a[i])][ALPHABET.index(b[j])])

    return dp[a_len-1][b_len-1]


def editex():
    mis_f = open("../data/misspell.txt", 'r')
    dic_f = open("../data/dictionary.txt", 'r')
    res_f = open("../result/editex", 'w')

    # read dictionary
    dic = []
    for line in dic_f.readlines():
        line = line.strip()
        dic.append(line)
    dic_f.close()

    # process misspell file
    for line in mis_f.readlines():
        print ('\n' + line,)    # test
        line = line.strip()
        # change special symbol to '#'
        for i in range(len(line)):
            if ALPHABET.index(line[i]) == -1:
                line[i] = '#'
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
            print(dic[i] + '\t')    # test
        res_f.write('\n')
    res_f.close()
    mis_f.close()

def main():
    editex()
if __name__ == "__main__":
    main()
