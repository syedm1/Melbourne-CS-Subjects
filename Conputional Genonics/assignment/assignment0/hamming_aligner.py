#!/usr/lib/python2.7
#Group member: Haonan Li

def reverse(read):
    reverse_read = ""
    read = read[::-1]   #reverse the read
    # get comlimentary read
    for i in range(len(read)):
        if read[i] == 'A':
            reverse_read += 'T'
        elif read[i] == 'T':
            reverse_read += 'A'
        elif read[i] == 'G':
            reverse_read += 'C'
        elif read[i] == 'C':
            reverse_read += 'G'
    return reverse_read

def hamming_distance(a, b):
    dis = 0
    for i in range(len(a)):
        if a[i] != b[i]:
            dis += 1
        if dis > 2:
            return dis
    return dis

def hamming_match(read, ref):
    pos = ref.find(read, 0)
    pos_set = set()
    ref_len = len(ref)
    read_len = len(read)
    min_dis = 99
    # forward search
    for i in range(ref_len-read_len):
        dis = hamming_distance(read, ref[i:i+read_len])
        if dis < min_dis:
            min_dis = dis
            pos_set.clear()
            pos_set.add(i)
        elif dis == min_dis:
            pos_set.add(i)

    #reverse search
    if reverse(read) == read:
        pass
    else:
        read = reverse(read)
        for i in range(ref_len-read_len):
            dis = hamming_distance(read, ref[i:i+read_len])
            if dis < min_dis:
                min_dis = dis
                pos_set.clear()
                pos_set.add(0-i)
            elif dis == min_dis:
                pos_set.add(0-i)
    return (min_dis, pos_set)
    

def alignment():
    f1 = open("reads.fa", "r")
    f2 = open("reference.fa", "r")
    f3 = open("hamming_alignment.txt", "w")

    ref = ">"   # add this for convinience of 1-based coordinatin
    f2.readline()
    for line in f2.readlines():
        line = line.strip()
        ref += line
    f2.close()

    f3.write("READ_NEME\tREF_NAME\tPOS\tSTRAND\tNUMBER_OF_ALIGNMENTS\tHAMMING_DISTANCE\n")
    line = f1.readline()
    while line:
        read_name = line.strip()
        f3.write(read_name + '\t')
        line = f1.readline()
        f3.write("ref" + '\t')
        
        (ham_dis, pos_set) = hamming_match(line, ref)

        # write file
        min_dis = 9999
        strand = ""
        for item in pos_set:
            if abs(item) < min_dis:
                min_dis = abs(item)
                if item < 0:
                    strand = "-"
                else:
                    strand = "+"
        f3.write(str(min_dis) + "\t" + strand)
        f3.write('\t' + str(len(pos_set)) + '\t' + str(ham_dis) + '\n' )

        line = f1.readline()
    f1.close()
    f2.close()
    f3.close()

def statistic():
    f1 = open("hamming_alignment.txt", "r")
    f1.readline()
    count = [0 for i in range(20)]
    for line in f1.readlines():
        line = line.strip()
        line = line.split()
        count[int(line[-1])] += 1
    print ("pos \treads_num")
    for i in range (20):
        print (str(i) + '\t' + str(count[i]))

def main():
    alignment()
    statistic()

if __name__ == "__main__":
    main()
