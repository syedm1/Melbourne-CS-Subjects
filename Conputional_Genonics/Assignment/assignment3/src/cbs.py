#!usr/lib/python2.7
# Auther    : Haonan Li <haonanl5@student.unimelb.edu.au>
# Porpuse   : Circular Binary Segmentation algorithm

import getopt
import sys
import numpy as np
import math
import matplotlib.pyplot as plt


# input the bins
def input_bin(bin_file):
    bin_f = open(bin_file,'r')
    # read table title
    bin_f.readline()
    # bins and position index
    bins = []
    index = []
    for line in bin_f.readlines():
        line = line.strip().split()
        # average copy number
        acn = float(line[3]) / (int(line[2])-int(line[1])) 
        index.append((int(line[1]),int(line[2])))
        bins.append(acn)
    ch = line[0]
    bin_f.close()
    return bins,index,ch


# visulization log-ratio with highlight cnv
def plot_cnv(X, cnvi):
    x = np.array(range(len(X)))
    # y1 = np.zeros((len(X)))
    # plt.plot(x,y1)
    # plot all log-ratio
    plt.scatter(x,X,s=10)
    cnvx = []
    cnvy = []
    for seg in cnvi:
        cnvx += [i for i in range(seg[0],seg[1])]
        cnvy += list(X[seg[0]:seg[1]])
    # plot cnvs
    plt.scatter(cnvx,cnvy,s=10,marker='*',color='r')
    plt.show()


# output the segments with abs average log-ratio >= 0.1
def output(X,I,index,out_file,ch):
    out_f = open(out_file,'w')
    # change point index
    cpi = np.where(I >= 1)
    cpi = cpi[0]
    print cpi
    # change points
    cps = [index[i][1] for i in cpi]
    # save CNV index and CNVs
    cnvi = []
    cnv = []
    for i in range(len(cps)-1):
        T = X[cpi[i]+1:cpi[i+1]]
        if len(T)>0:
            avg = np.average(T)
        else:
            avg = 0.0
        if abs(avg) >= 0.1:
            cnvi.append((cpi[i]+1,cpi[i+1]))
            cnv.append((cps[i],cps[i+1],avg))
    # output cnv
    for seg in cnv:
        out_f.write('%s\t%d\t%d\t%f\n'%(ch,seg[0],seg[1],seg[2]))
    out_f.close()
    # plot
    # plot_cnv(X,cnvi)
    

# recursive cbs
def cbs(X,I,a,b,t):
    
    # too near
    if b-a < 3:
        return I

    # S : cumulative sum of first n bins
    X_ = X[a:b]
    S = np.copy(X_)
    n = len(S)
    for i in range(n):
        S[i] = X_[0:i+1].sum()

    # Z : 
    Z = np.zeros((n,n))
    for i in range(0,n):
        for j in range(i+1,n):
            coef = 1 / math.sqrt(1.0/(j-i) + 1.0/(n-j+i))
            factor = (S[j]-S[i])/(j-i) - (S[n-1]-S[j]+S[i])/(n-j+i)
            Z[i,j] = coef * factor

    # find max value and position
    maximum = np.max(Z)
    if maximum < t:
        return I
    else:
        # find change points recursively
        pos = np.where(Z == maximum)
        pos1 = a + min(pos[0][0],pos[1][0])
        pos2 = a + max(pos[0][0],pos[1][0])
        # print pos1,pos2,a,b
        # boundary detect
        if abs(pos1-a)>1:
            I[pos1] += 1
        if abs(pos2-b)>2:
            I[pos2] += 1
        I1 = cbs(X,I,a,pos1+1,t)
        I2 = cbs(X,I,pos1+1,pos2+1,t)
        I3 = cbs(X,I,pos2+1,b,t)
        return I1 + I2 + I3


# init the log-ratio data
def cbs_init(bin_file, threshold, out_file):

    # CBS initialization
    bins,index,ch = input_bin(bin_file)
    
    # speed up with numpy
    bins = np.array(bins)
    n = len(bins)
    
    # X : log ratios of each bin
    X = np.log2(bins / np.median(bins[:n/3]))
    X[X > 2] = 0
    X[X < -5] = 0
    
    # I : segmentation index
    I = np.zeros((n))
    I[0] = 1
    I[n-1] = 1

    # call cbs resursion
    cbs(X,I,0,n,threshold)
    
    # output
    output(X,I,index,out_file,ch)


# Usage of the tool
def usage():
   print ("usage:python phaser.py [options] ... [-b bins | -z threshold] ...")
   print ("Options and arguments:")
   print ("-h     :Help")
   print ("-b     :Input bins.")
   print ("-z     :Z threshold")
   print ("-o     :Output file")


def main(argv):
    try:
        opts, args = getopt.getopt(argv[1:], "hb:z:o:", \
        ["bin=", "threshold=", "output="])
    except getopt.GetoptError:
        usage()
        sys.exit(2)
    for opt, arg in opts:
        if opt in ('-h', '--help'):
            usage()
            sys.exit()
        elif opt in ('-b', '--bin='):
            bin_file = arg
        elif opt in ('-z', '--threshold='):
            threshold = float(arg)
        elif opt in ('-o', '--output='):
            out_file = arg
    
    # Make sure the parameters were defined
    if not('bin_file' in locals().keys()) or \
       not('threshold' in locals().keys()) or \
       not('out_file' in locals().keys()):
        usage()
        sys.exit()
       
    # main process
    cbs_init(bin_file, threshold, out_file)


if __name__ == "__main__":
    main(sys.argv)

