#!/usr/bin/python
import functools
import operator
import math

MAX_SIZE=1000000

trans = [
[0.18,0.27,0.42,0.12,0.01,0.01,0.01,0.01],
[0.17,0.36,0.27,0.18,0.01,0.01,0.01,0.01],
[0.16,0.33,0.37,0.12,0.01,0.25,0.13,0.25],
[0.08,0.35,0.38,0.12,0.01,0.01,0.01,0.01],
[0.01,0.01,0.01,0.01,0.30,0.2,0.29,0.20],
[0.01,0.5,0.01,0.01,0.32,0.30,0.28,0.21],
[0.01,0.01,0.01,0.01,0.18,0.33,0.29,0.33],
[0.01,0.17,0.01,0.01,0.25,0.25,0.20,0.21]
]

base2int = {
    'A':0,
    'C':1,
    'G':2,
    'T':3
}
int2state = {
    0:'A+',
    1:'C+',
    2:'G+',
    3:'T+',
    4:'A-',
    5:'C-',
    6:'G-',
    7:'T-'
}


def b2int(base):
    return base2int[base]
def int2s(i):
    return int2state[i]

emit = [
    [1, 0, 0, 0],
    [0, 1, 0, 0],
    [0, 0, 1, 0],
    [0, 0, 0, 1],
    [1, 0, 0, 0],
    [0, 1, 0, 0],
    [0, 0, 1, 0],
    [0, 0, 0, 1]
    ]

def g(v0, l):
	(kmax, vmax) = max(enumerate([v0[k]+ math.log(trans[k][l]) for k in range(8)]), 
		key=operator.itemgetter(1)) 
	return (kmax, vmax)

def f((v0, trace0), y):
	v = []
	trace = []
	for l in range(8):
		(kmax, vmax) = g(v0, l)
                if l in [y, y+4]:
                    v.append(emit[l][y] * vmax)
                else:
                    v.append(-MAX_SIZE)
		trace.append(trace0[l] + [kmax])
	return (v, trace)

def viterbi(lis):
    obs = map(b2int, lis) 
    return functools.reduce(f, obs, ([0]*len(obs), [[''] for i in obs]))

seq = "GGCAAAGCAAAACCGCGCCGCGATT"
(v, trace) = viterbi(seq) 
(kmax, vmax) = max(enumerate([v[k] for k in range(8)]), key=operator.itemgetter(1)) 
n = len(trace[0])-1

# trace-back
idx = [kmax]
while n>0:
    kmax = trace[kmax][n]
    n = n-1
    idx = [kmax] + idx

print "seq =", seq
print "state =", map(int2s, idx)[1:]
