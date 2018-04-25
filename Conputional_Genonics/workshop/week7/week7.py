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

print prob(counts, ["C+","G+","C+","G+","G+","C+","A+","C+","G+","C+"])

seq2 = "CGCGGCACGC"
seq3 = "CTCTCGCGCG"

#def best_path(transitions, seq, last):
#    if len(seq) == 1:
#        return max(transitions[last][seq+"+"], transitions[last][seq+"-"])
#    return max(transitions[last][seq[0]+"+"] * best_path(transitions, seq[1:], seq[0]+"+"), transitions[last][seq[0]+"-"] * best_path(transitions, seq[1:], seq[0]+"-"))
#
#print best_path(counts, seq2[1:], "C+")
#print best_path(counts, seq3[1:], "C-")


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
    print 'highest probability is:' + str(max)
    print 'the best path is:' + maxp

brute_force_paths(counts, seq2)
brute_force_paths(counts, seq3)

