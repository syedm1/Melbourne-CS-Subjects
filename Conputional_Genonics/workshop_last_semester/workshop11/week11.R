library(edgeR)
data=read.table('gene_expression.txt', skip=1)
head(data)

keep <- rowSums(data[,2:7] > 0.5) >= 3
data = data[keep, ]
data$logFC = log2(rowSums(data[,2:4])/rowSums(data[,5:7]))
background=data[order(abs(data$logFC), decreasing=F),][1:(dim(data)[1]*0.8),]
summary(background$logFC)
data$Pval = -1
for(i in 1:dim(data)[1]){data[i, "Pval"] = t.test(x=data[i,2:4],y=data[i,5:7], var.equal=F)$p.value}
# Bonferroni 
data$adj = data$Pval*length(data$Pval)
# Benjamini-Hochberg 
FDR = 0.01
sorted <- sort(data$Pval)
BH <- sorted[sorted <= c(1:length(sorted))*FDR/length(sorted)]

sum(data$Pval <= 0.05)/dim(data)[1]
sum(data$adj <= 0.05)/dim(data)[1]
length(BH)/dim(data)[1]
