f = open('../data/ref', 'r')
line = f.readline()
line = line.strip().split()
start = int(line[0])-1
ref = f.readline()

pos = 28356471
print ref[(pos-start):(pos-start+100)]
