counts = {"A+": {"A+":0, "A-":0, "C+":0, "C-":0, "G+":0, "G-":0, "T+":0, "T-":0},
          "A-": {"A+":0, "A-":0, "C+":0, "C-":0, "G+":0, "G-":0, "T+":0, "T-":0}, 
          "C+": {"A+":0, "A-":0, "C+":0, "C-":0, "G+":0, "G-":0, "T+":0, "T-":0},
          "C-": {"A+":0, "A-":0, "C+":0, "C-":0, "G+":0, "G-":0, "T+":0, "T-":0},
          "G+": {"A+":0, "A-":0, "C+":0, "C-":0, "G+":0, "G-":0, "T+":0, "T-":0},
          "G-": {"A+":0, "A-":0, "C+":0, "C-":0, "G+":0, "G-":0, "T+":0, "T-":0},
          "T+": {"A+":0, "A-":0, "C+":0, "C-":0, "G+":0, "G-":0, "T+":0, "T-":0},
          "T-": {"A+":0, "A-":0, "C+":0, "C-":0, "G+":0, "G-":0, "T+":0, "T-":0}
}

seq = "GGTTCCGCTCCTACCGCGCCGGCGTTCGGCCACGTT"
isl = "-----++-------++++-++++++-++--++++--"

last = seq[0]+isl[0]
for base, status in zip(seq[1:],isl[1:]):
    state = base + status
    counts[last][state] += 1
    last = state

#print counts

for count_table in counts.values():
    total = sum(count_table.values())
    for b in count_table:
        count_table[b] = float(count_table[b])/total

#print counts

def prob(transitions, path):
    prob = 1
    for i in range(len(path)-1):
        prob *= transitions[path[i]][path[i+1]]
    return prob

#print prob(counts, ["C+","G+","C+","G+","G+","C+","A+","C+","G+","C+"])


def brute_force_paths(transitions, seq):
    paths = [seq[0]+"+", seq[0]+"-"]
    for b in seq[1:]:
        newpaths = []
        for i in range(len(paths)):
            newpaths.append(paths[i]+b+"-")
            paths[i] = paths[i]+b+"+"
        paths = paths + newpaths
    max = 0
    maxp = None
    for p in paths:
        probp = prob(transitions, [p[i:i+2] for i in range(0, len(p), 2)])
        if probp > max:
            max = probp
            maxp = p
    max = max * 0.125
    print 'result of brute force algorithm:'
    print 'highest probability is: ' + str(max)
    print 'the best path is: ' + maxp


def viterbi(obs, states, start_p, trans_p, emit_p):
    V=[{}]
    for i in states:
        V[0][i]=start_p[i]*emit_p[i][obs[0]]
    # Run Viterbi when t > 0
    for t in range(1, len(obs)):
        V.append({})
        for y in states:
            prob = max([V[t-1][y0] * trans_p[y0][y] * emit_p[y][obs[t]] for y0 in states])
            V[t][y] = prob
#it prints a table of steps from dictionary
#        for i in dptable(V):
#            print i
#        print '--------------------------'
        opt=[]
        for j in V:
            for x,y in j.items():
                if j[x]==max(j.values()):
                    opt.append(x)
                    break

    #the highest probability
    h=max(V[-1].values())
    print 'result of Viterbi algorithm:'
    print 'highest probability is: ' + str(h) 
    print 'the best path is: ' + ''.join(opt)
    
def dptable(V):
    yield " ".join(("%10d" % i) for i in range(len(V)))
    for y in V[0]:
        yield "%.7s: " % y+" ".join("%.7s" % ("%f" % v[y]) for v in V)

states = ('A+', 'A-','C+','C-','G+','G-','T+','T-')
start_p = {"A+":0.125,
           "A-":0.125,
           "C+":0.125,
           "C-":0.125,
           "G+":0.125,
           "G-":0.125,
           "T+":0.125,
           "T-":0.125
}
emission_p = {"A+":{'A':1,'C':0,'G':0,'T':0}, 
              "A-":{'A':1,'C':0,'G':0,'T':0},
              "C+":{'A':0,'C':1,'G':0,'T':0}, 
              "C-":{'A':0,'C':1,'G':0,'T':0}, 
              "G+":{'A':0,'C':0,'G':1,'T':0},
              "G-":{'A':0,'C':0,'G':1,'T':0},
              "T+":{'A':0,'C':0,'G':0,'T':1},
              "T-":{'A':0,'C':0,'G':0,'T':1}
}

seq2 = "CGCG"
seq3 = "CTCTCGCGCG"

brute_force_paths(counts, seq3)
print '--------------------------------------'
viterbi(seq3, states, start_p, counts, emission_p)
