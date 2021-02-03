# if (!requireNamespace("BiocManager"))
#   install.packages("BiocManager")
# BiocManager::install(c("limma", "edgeR", "Glimma", "org.Mm.eg.db", "gplots", "RColorBrewer", "NMF", "BiasedUrn"))

i<-0
i

.libPaths("D:\\Documents\\R\\win-library\\4.0")
library("readr")
phenotype <- read.csv("data\\PHENOTYPE.csv",sep=",")
gene_count <- read.csv("data\\HTSEQ.csv",sep=",")
write_tsv(gene_count,"data\\htseq_counts_f.txt"," ")

wild_type<-phenotype[c("sample_type.samples")]
phenotype$sample_type.samples<-replace(phenotype$sample_type.samples,phenotype$sample_type.samples != "Solid Tissue Normal","Tumor");
wild_type<-replace(phenotype$sample_type.samples,phenotype$sample_type.samples == "Solid Tissue Normal", "Healthy");
x<-data.frame("Patient_id"=phenotype$submitter_id.samples,"Wild type"=wild_type)

id <- colnames(gene_count)
id <- gsub("[.]","-",id)
id<- as.data.frame(id)

x <-merge(x,id,by.x = "Patient_id",by.y="id")
x <- as.data.frame(x)

x$Patient_id <- gsub("-",".",x$Patient_id)
table(x$Wild.type)
write_tsv(x,"data\\phenotype.txt")
