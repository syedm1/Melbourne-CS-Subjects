# TASK 1 and 2
vals = matrix(scan('mapped_pairs.wig', skip=1),ncol=1,byrow=TRUE)
vals = log2((vals+1) / mean(vals))
D = dist(vals)
hc = hclust(D)
png('values.png'); plot(hc,xlab="Values",ylab="Height"); dev.off()


# TASK 3
idx <- cutree(hc, h=0.5) # cut tree at height 0.5
print(length(unique(idx))) # number of clusters
cluster1 <- vals[idx ==1] # cluster 1
summary(cluster1)


# TASK 4
hc = hclust(D, method="average") # linkage = average
png('linkage.png'); plot(hc,main="With average linkage",xlab="Counts",ylab="Height"); dev.off()

# cluster values x position
pairs = cbind(vals, 1:length(vals)) 
D = dist(pairs)
hc = hclust(D)
png('position.png'); plot(hc, xlab="Bins",ylab="Height"); dev.off()
idx <- cutree(hc, h=500)
print(length(unique(idx))) 
cluster1 <- pairs[idx ==1]

# More readable output
hcd = as.dendrogram(hc)
dend = cut(hcd, h = 500)
png('alt.png')
op = par(mfrow = c(2, 1))
plot(dend$upper, main = "Upper tree of cut at h=500",xlab="Bins",ylab="Height")
lwr <- do.call(merge, dend$lower)
plot(lwr, main = "Lower of cut at h=500",xlab="Bins",ylab="Height")
