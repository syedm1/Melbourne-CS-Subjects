#!/use/local/bin/python2.7

import os
import sys
import random
import commands

pieces = ["BK","BQ","BR","BR","BB","BB","BN","BN","BP","BP","BP","BP","BP","BP","BP","BP","WK","WQ","WR","WR","WB","WB","WN","WN","WP","WP","WP","WP","WP","WP","WP","WP"]

out_f = open("result", "w")


total_guess = 0
# test times
times = 100
# game size
n = 27
for i in range(times):
    s = set()
    # generate random target set  
    for j in range(n):
        new = random.randint(0,31)
        if new in s:
            pass
        else:
            s.add(new)
    # command line query
    query = "./Project2Test " + str(n) + ' '
    for j in s:
        query = query + pieces[j] + ' '
    # get output
    (status, output) = commands.getstatusoutput(query)
    sp_output = output.split()
    out_f.write(output)
    out_f.write('\n\n')
    total_guess += int(sp_output[len(sp_output)-2])

print "Average guess time: ", float(total_guess)/times
