#!usr/local/bin/python2.7
# Name Haonan Li
# Student ID: 955022

import sys
import os

# map from letter to number
letter_group = ["aehiouwy", "bpfv", "cgjkqsxz", "dt", "l", "mn", "r"]
soundex_dict = {}
for i in range (len (letter_group)):
    for ch in letter_group[i]:
        soundex_dict[ch] = i

def string2soundex(a):
    res = a[0]
    # translate and remove dumplicate
    last_num = 7
    for ch in a[1:]:
        if ch in soundex_dict:
            cur_num = soundex_dict[ch]
        else:
            cur_num = 7
        if cur_num == last_num:
            pass
        else:
            res += str(cur_num)
            last_num = cur_num
    # remove 0
    res = res.replace('0', '')
    if len(res)>3:
        return res[:3]
    else:
        return res

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
            # scheme1, indel and replace +1, match 0
            # dp[i][j] = min(dp[i-1][j]+1, dp[i][j-1]+1, dp[i-1][j-1]+(0 if a[i-1] == b[j-1] else 1))
            # scheme2, indel and replace +1, match -1
            dp[i][j] = min(dp[i-1][j]+1, dp[i][j-1]+1, dp[i-1][j-1]+(-1 if a[i-1] == b[j-1] else 1))
    return dp[a_len-1][b_len-1]

def soundex():
    mis_f = open("../data/misspell.txt", 'r')
    dic_f = open("../data/dictionary.txt", 'r')
    res_f = open("../result/soundex", 'w')

    # read dictionary
    dic = []
    for line in dic_f.readlines():
        line = line.strip()
        dic.append((line, string2soundex(line)))
    dic_f.close()

    # process misspell file
    for line in mis_f.readlines():
        # print ('\n' + line,)    # test
        line = line.strip()
        sounde_line = string2soundex(line)
        # compute the similarity
        min_dis = 99
        min_set = set()
        for i in range(len(dic)):
        # for i in range(50):
            dis = distance(dic[i][1], sounde_line)
            if dis < min_dis:
                min_dis = dis
                min_set.clear()
                min_set.add(i)
            elif dis == min_dis:
                min_set.add(i)
        # print min_set
        res_f.write(str(min_dis) + '\t')
        for i in min_set:
            res_f.write(dic[i][0] + '\t')
            # print(dic[i][0] + '\t')    # test
        res_f.write('\n')
    res_f.close()
    mis_f.close()

def main():
    soundex()
if __name__ == "__main__":
    main()
