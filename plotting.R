library(edgeR)
library(limma)
library(Glimma)
library(gplots)
library(RColorBrewer)
library(NMF)
library(ggplot2)

seqdata <- read.delim("ht_seq.txt", stringsAsFactors = FALSE)
# Read the sample information into R
sampleinfo <- read.delim("phenotype.txt", stringsAsFactors = TRUE)
countdata <- seqdata[,-(1:1)]
dim(seqdata)

rownames(countdata) <- seqdata[,1]
countdata <- countdata[,order(names(countdata))]

colnames(countdata)

table(colnames(countdata)==sampleinfo$Patient_id)

y <- DGEList(countdata)
names(y)
group <- paste(sampleinfo$Wild.type)
group <- factor(group)
y$samples$group <- group

myCPM <- cpm(countdata)
thresh <- myCPM > 0.5
keep <- rowSums(thresh) >= 2
y <- y[keep, keep.lib.sizes=FALSE]

logcounts <- cpm(y,log=TRUE)

var_genes <- apply(logcounts, 1, var)
head(var_genes)

select_var <- names(sort(var_genes, decreasing=TRUE))[1:5]
head(select_var)

# var_id1 <- select_var[2]

gene_count <- read.csv("data\\TCGA-PRAD.htseq_counts.tsv",sep="\t",row.names = 1)
top_genes <- data.frame();
i <- 0;
for(var in select_var){
  i <- i+1
  index <- which(rownames(gene_count) == var)
  gene_expression <- t(gene_count[index,])
  r_name <- paste("G",toString(i))
  transposed <- data.frame("Gene"=r_name,"Gene_Expression" = gene_expression[,1],"Status" = x$Wild.type)
  top_genes <- rbind(top_genes,transposed)
}

jpeg("plots\\violin_plot.jpeg")
ggplot(top_genes,aes(Gene,Gene_Expression,fill = Status)) + geom_violin(trim="False") +  facet_wrap(~Status) +ggtitle("Violin")
dev.off()

jpeg("plots\\box_plot.jpeg")
ggplot(top_genes, aes(x=Gene, y=Gene_Expression, fill=Status)) + geom_boxplot()
dev.off()
