import sys
import matplotlib.pyplot as plt

f = open(sys.argv[1], 'r')
freq = []
qs_ave = []
pos = []
for row in f:
    pos.append(row.split('\t')[0]+':'+row.split('\t')[1])
    freq.append(row.split('\t')[3])
    qs_ave.append(row.split('\t')[4])

plt.scatter(freq,qs_ave)
plt.show()
