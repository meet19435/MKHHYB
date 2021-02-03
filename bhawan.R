
.libPaths("D:\\Documents\\R\\win-library\\4.0")
library(edgeR)
library(limma)
# library(Glimma)
library(gplots)
library(RColorBrewer)
library(NMF)
library(ggplot2)
seqdata <- read.delim("data\\htseq_counts_f.txt", stringsAsFactors = FALSE)
# Read the sample information into R
sampleinfo <- read.delim("data\\phenotype.txt", stringsAsFactors = TRUE)
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



myCPM <- cpm(countdata)
thresh <- myCPM > 0.5
keep <- rowSums(thresh) >= 2
y <- y[keep, keep.lib.sizes=FALSE]
names(y)

logcounts <- cpm(y,log=TRUE)

var_genes <- apply(logcounts, 1, var)


select_var <- names(sort(var_genes, decreasing=TRUE))[1:5]
highly_variable_lcpm <- logcounts[select_var,]
dim(highly_variable_lcpm)

y <- calcNormFactors(y)
design <- model.matrix(~0+group)
colnames(design) <- levels(group)
design
par(mfrow=c(1,1))
v <- voom(y,design,plot = TRUE)
names(v)
fit <- lmFit(v)
cont.matrix <- makeContrasts(B.HealthyVsUnhealthy=Healthy - Tumor,levels=design)
fit.cont <- contrasts.fit(fit, cont.matrix)
fit.cont <- eBayes(fit.cont)
dim(fit.cont)
names(fit.cont)


summa.fit <- decideTests(fit.cont)
summary(summa.fit)



jpeg("plots\\hm_plot.jpeg")
hm_plot<-plotMD(fit.cont,coef=1,status=summa.fit[,"B.HealthyVsUnhealthy"], values = c(-1, 1), hl.col=c("blue","red"))
dev.off()

jpeg("plots\\v_plot.jpeg")
v_plot<-volcanoplot(fit.cont,coef=1,highlight=5,names=fit.cont$genes$SYMBOL, main="B.HealthyVsUnhealthy")
dev.off()


gene_count <- read.csv("data\\HTSEQ.csv",sep=",",row.names = 1)
gene_name <- read.csv("data\\PROBEMAP.csv",sep=",");
x <- read.delim("data\\phenotype.txt", stringsAsFactors = TRUE)
top_genes <- data.frame();
i <- 0;
for(var in select_var){
  i <- i+1
  index <- which(rownames(gene_count) == var)
  gene_expression <- t(gene_count[index,])
  # gene_expression
  r_name <- gene_name$gene[which(gene_name$id == select_var[i])]
  transposed <- data.frame("Gene"=r_name,"Gene_Expression" = gene_expression[,1],"Status" = x$Wild.type)
  top_genes <- rbind(top_genes,transposed)
}

jpeg("plots\\violin_plot.jpeg")
ggplot(top_genes,aes(Gene,Gene_Expression,fill = Status)) + geom_violin(trim="False") +  facet_wrap(~Status) +ggtitle("Violin") + coord_flip()
dev.off()

jpeg("plots\\box_plot.jpeg")
ggplot(top_genes, aes(x=Gene, y=Gene_Expression, fill=Status)) + geom_boxplot() + coord_flip()
dev.off()
