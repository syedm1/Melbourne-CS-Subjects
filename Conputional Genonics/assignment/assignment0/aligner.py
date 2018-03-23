#!/usr/lib/python2.7
#Group member: Haonan Li, Muqing Li

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

def alignment():
    f1 = open("reads.fa", "r")
    f2 = open("reference.fa", "r")
    f3 = open("alignment.txt", "w")

    ref = ">"   # add this for convinience of 1-based coordinatin
    f2.readline()
    for line in f2.readlines():
        line = line.strip()
        ref += line
    f2.close()

    f3.write("READ_NEME\tREF_NAME\tPOS\tSTRAND\tNUMBER_OF_ALIGNMENTS\n")
    line = f1.readline()
    while line:
        read_name = line.strip()
        f3.write(read_name + '\t')
        line = f1.readline()

        # forward search
        read = line.strip()
        f3.write("ref" + '\t')
        pos = ref.find(read, 0)
        pos_list = []
        while pos != -1:
            pos_list.append(pos)
            pos = ref.find(read, pos+1)
        
        #reverse search
        if reverse(read) == read:
            pass
        else:
            read = reverse(read)
            pos = ref.find(read, 0)
            while pos != -1:
                if len(pos_list)>0 and pos < pos_list[0]:
                    pos_list[0] = 0-pos
                pos_list.append(0-pos)  # "-" is reverse signal
                pos = ref.find(read, pos+1)
        
        # write file
        if len(pos_list) == 0:
            f3.write("0\t*")
        elif pos_list[0] > 0:
            f3.write(str(pos_list[0]) + "\t+")
        else:
            f3.write(str(0-pos_list[0]) + "\t-")
        f3.write('\t' + str(len(pos_list)) + '\n')

        line = f1.readline()
    f1.close()
    f2.close()
    f3.close()

def statistic():
    f1 = open("alignment.txt", "r")
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
