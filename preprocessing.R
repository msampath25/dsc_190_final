# This script is to trim down our datasets so that analysis becomes
# faster. 

library(data.table)
library(plink2R)
knitr::opts_knit$set(root.dir = '~/Documents/GitHub/dsc_190_final/')

gene_number = 50

# filter the geuvadis gene expression data down to gene_number genes and only keep
# people in our genotype data

ge <-fread('GD462.GeneQuantRPKM.50FN.samplename.resk10.txt.gz')
filtered_ge <- ge[1:gene_number, ]


# arbitrarily read in one genotype file to get the people ids
gt <- read_plink(paste0('~/Documents/GitHub/dsc_190_final/eur_1000G/1000G_eur_chr', 22))
people <- which(colnames(ge) %in% gt$fam$V1)
people <- colnames(ge)[people]
filtered_ge <- as.matrix(filtered_ge)[, people]

write.table(filtered_ge, file="~/Documents/GitHub/dsc_190_final/filtered_geuvadis_dataset.tsv", row.names=F, col.names=T, sep = '\t', quote = F)






