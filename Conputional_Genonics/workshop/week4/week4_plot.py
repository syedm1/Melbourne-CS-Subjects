import matplotlib.pyplot as plt
import sys

f = open(sys.argv[1], 'r')
count = [[],[]]
for row in f:
  #print row
  #print row.split('\t')[5]
  if row.split('\t')[5] == '0\n':
    count[0].append(int(row.split('\t')[4]))
  elif row.split('\t')[5] == '1\n':
    count[1].append(int(row.split('\t')[4]))
plt.boxplot(count)
plt.xticks([1, 2], ['ham = 0','ham = 1'])
plt.show()
plt.savefig('distribution.png')
