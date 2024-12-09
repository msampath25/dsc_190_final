# DSC 190/291 Final Project
In this project, we try to improve cis gene models by experimenting with using genome-wide variants and using epigenetic annotation bins (Enhancers, ATAC-seq, and Hi-C domains).

- Analysis starts with 
    - plink genotpes files (.bed/.bim/.fam files)
    - gene expression data (csv file with genes on columns and individuals on rows)
    - quantitative and categorical covariates such as sex, age etc. (Note the scripts below automatically calculate genetic PCs and gene expression PCs that can be combined with general covariates)
    - Epigenetic annotations (essentially tab-separated or space-separated .bed files with chr, start, end in the first three columns)
- Prepare data for running regular cis-gene models using `prep_gene_model/prep_gene_model.sh`.
- Prepare data for running regular trans-gene models using `prep_gene_model/prep_gene_model_trans.sh`. This runs MatrixEQTL R package with a modest p-value theshold to subset genomewide SNPs and use SNPs that likely impact gene expression. (Note: Some genes might not have any significant eQTLs after this. We list all the genes that had at least some eQTLs in genes_with_transeqtls.txt, but the script does not perform this.)
- Create genome-wide epigenetic bins using `bed_intersect.sh`
- Get cis and trans variants included in each epigenetic bin for all genes and build gene models using `prep_gene_model/prep_epi_gene_model.sh` and `prep_gene_model/prep_epi_gene_model_trans.sh`.
- Run the created scripts that will run FUSION to create gene models. For example, the scripts inside `run_fusion/`.
- Analyze the gene models created and get a table of hsq and R-sq for cis (or trans) baesline and epigenetic gene models using `analyze_gene_model/get_r2.R`
- Visualize number of cis (or trans) SNPs in each epigenetic bins with total (baseline) using `snp_bin.sh` or `snpcounts_gene_by_bin.sh`