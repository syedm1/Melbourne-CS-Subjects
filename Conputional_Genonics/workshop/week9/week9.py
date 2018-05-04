import numpy as np
import math

start_p = {'CP0':0.2,
           'CP1':0.2,
           'CP2':0.2,
           'CP3':0.2,
           'CP4':0.2}
states = ['CP0','CP1','CP2','CP3','CP4']
emissions = [i for i in range(1,21)]
#convert probability table to dictionary

def table2dict(table, cols):
    dic = {}
    for row in table:
        temp_dict = {}
        for i in range(len(row)-1):
            temp_dict[cols[i]] = row[i+1]
        dic[row[0]] = temp_dict
    return dic

trans_table = np.genfromtxt('transitions.txt',dtype=None,skip_header=1)
emission_table = np.genfromtxt('emissions.txt',dtype=None,skip_header=1)

trans_p = table2dict(trans_table, states)
emission_p = table2dict(emission_table, emissions)

def viterbi(obs, states, start_p, trans_p, emit_p):
    V = [{}]
    for st in states:
        V[0][st] = {"prob": start_p[st] * emit_p[st][obs[0]], "prev": None}
    # Run Viterbi when t > 0
    for t in range(1, len(obs)):
        V.append({})
        for st in states:
            max_tr_prob = max(V[t-1][prev_st]["prob"]*trans_p[prev_st][st] for prev_st in states)
            for prev_st in states:
                if V[t-1][prev_st]["prob"] * trans_p[prev_st][st] == max_tr_prob:
                    max_prob = max_tr_prob * emit_p[st][obs[t]]
                    V[t][st] = {"prob": max_prob, "prev": prev_st}
                    break
    #for line in dptable(V):
    #    print line
    opt = []
    # The highest probability
    max_prob = max(value["prob"] for value in V[-1].values())
    previous = None
    # Get most probable state and its backtrack
    for st, data in V[-1].items():
        if data["prob"] == max_prob:
            opt.append(st)
            previous = st
            break
    # Follow the backtrack till the first observation
    for t in range(len(V) - 2, -1, -1):
        opt.insert(0, V[t + 1][previous]["prev"])
        previous = V[t + 1][previous]["prev"]

    print 'The steps of states are ' + ' '.join(opt) + ' with highest probability of %s' % max_prob

def dptable(V):
    # Print a table of steps from dictionary
    yield " ".join(("%12d" % i) for i in range(len(V)))
    for state in V[0]:
        yield "%.7s: " % state + " ".join("%.7s" % ("%f" % v[state]["prob"]) for v in V)


#-------------------------------------------------------
#bins = np.genfromtxt('bins.txt', skip_header=1)
#read_depths = [math.floor(row[2]/80)+1 for row in bins] 
#---why does this give all CP0 predictions?---
#-------------------------------------------------------

read_depths = [10,10,12,16,17,15,2,3,1,1,1]
viterbi(read_depths, states, start_p, trans_p, emission_p)
