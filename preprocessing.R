# This script is to trim down our datasets so that analysis becomes
# faster. 

library(data.table)
library(plink2R)
knitr::opts_knit$set(root.dir = '~/Documents/GitHub/dsc_190_final/')

gene_number = 50

# filter the geuvadis gene expression data down to gene_number genes and only keep
# people in our genotype data

ge <-fread('~/Documents/GitHub/dsc_190_final/GD462.GeneQuantRPKM.50FN.samplename.resk10.txt.gz')
no_X_ge <- ge[ge$Chr != 'X', ]
filtered_ge <- no_X_ge[1:gene_number, ]


# arbitrarily read in one genotype file to get the people ids
gt <- read_plink(paste0('~/Documents/GitHub/dsc_190_final/eur_1000G/1000G_eur_chr', 22))
people <- which(colnames(ge) %in% gt$fam$V1)
people <- colnames(ge)[people]
filtered_ge <- as.matrix(filtered_ge)[, people]

# lets normalize all of the gene expression values
filtered_ge <- t(sapply(1:nrow(filtered_ge), function(i) {
  y <- as.numeric(filtered_ge[i,])
  y <- (y - mean(y))/sd(y)
}))


# The above removes metadata related to genes so let's add this information back
# in
colnames(filtered_ge) <- people
filtered_ge <- cbind(as.matrix(no_X_ge[1:50, 1:4]), filtered_ge)


write.table(filtered_ge, file="~/Documents/GitHub/dsc_190_final/filtered_geuvadis_dataset.tsv", row.names=F, col.names=T, sep = '\t', quote = F)










