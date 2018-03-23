#!usr/local/bin/python2.7
# Name Haonan Li
# Student ID: 955022

import sys
import os

# n_gram distance
def distance(a, b):
    return len(a) + len(b) - 2 * len(a.intersection(b))
        
# n_gram set 
def ng_set(a, N):
    pat = ""
    for i in range(N-1):
        pat += "#"
    a = pat + a + pat
    ngset = set()
    for i in range(0, len(a)-N+1):
        ngset.add(a[i:i+N])
    return ngset
# print ng_set("adn", 3)
# print ng_set("ad", 3)

def n_gram(N):
    mis_f = open("../data/misspell.txt", 'r')
    dic_f = open("../data/dictionary.txt", 'r')
    outputf = "../result/n_gram" + str(N)
    res_f = open(outputf, 'w')

    # read dictionary
    dic = []
    dic_set = []
    for line in dic_f.readlines():
        line = line.strip()
        dic.append(line)
        dic_set.append(ng_set(line, N))
    dic_f.close()

    # process misspell file
    for line in mis_f.readlines():
        line = line.strip()
        line = ng_set(line, N)
        # compute the similarity
        min_dis = 99999
        min_set = set()
        for i in range(len(dic_set)):
        # for i in range(50):
            dis = distance(dic_set[i], line)
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
    for i in range(1, 10):
        n_gram(i)

if __name__ == "__main__":
    main()
