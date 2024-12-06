gt="/home/i3gupta/lustre/DSC291/data/geuvadis_hm3"
ge="/home/i3gupta/lustre/DSC291/data/geuvadis_gene_expression.csv"

out="/home/i3gupta/lustre/DSC291/data/out"

genes="/home/i3gupta/lustre/DSC291/data/geuvadis_gene_info.csv" # gene info
x=`basename $ge`
genes_subset="/home/i3gupta/lustre/DSC291/data/genes.txt"
SCRIPT_DIR=$(dirname "$(realpath "$0")")

################################################################################################
# Gene Phen files
################################################################################################

# python $SCRIPT_DIR/gene_phen.py $ge $out/gene_phen

################################################################################################
# Genetic PCs
################################################################################################

# rsq=0.8 # r2 threshold
# N=50 # number of variants in a widnow
# w=5 

# o=${out}/covars/N${N}_w${w}_rsq${rsq}
# mkdir -p $out/covars

# plink --bfile  $gt \
#     --exclude range $myex/data/high-LD-regions.txt \
#     --indep-pairwise $N $w $rsq \
#     --maf 0.05 \
#     --out $o

# rm $o.prune.out

# plink --bfile  $gt \
#     --extract $o.prune.in \
#     --make-bed \
#     --out $o.pruned

# plink --bfile $o.pruned --pca 10 --out $o
# rm $o.prune*

################################################################################################
# Gene Expression PCs
################################################################################################

# mkdir -p $out/covars/genexp_PCs
# Rscript $SCRIPT_DIR/genexp_PCs.R $ge $out/covars/genexp_PCs

################################################################################################
# # Combine covariates
################################################################################################

# python $SCRIPT_DIR/combine_covars.py -c $out/covars/gender.txt -g $out/covars/N${N}_w${w}_rsq${rsq}.eigenvec -x $out/covars/genexp_PCs.eigenvec -o $out/covars/combined.covars

################################################################################################
# # significant eqtl snps
################################################################################################

# Rscript $SCRIPT_DIR/matrixeqtl.R --bfile $gt --gene $ge --covar $out/covars/combined.covars --out $out/matrixeqtl.txt --pval 1e-3

mkdir -p $out/cissnps/trans_baseline
mkdir -p $out/cissnps/sigeqtls
for gene in `cat $genes_subset`; do
    grep $gene $out/matrixeqtl.txt | awk '{print $1}' > $out/cissnps/sigeqtls/${gene}.txt
#  (plink --bfile $gt --extract $out/cissnps/sigeqtls/${gene}.txt --make-bed --out "${out}/cissnps/trans_baseline/${gene}")&
done

################################################################################################
# # Make job files (one for each gene)
################################################################################################

# i=0
# for g in `cat $genes_subset`; do
# do

# (
# for x in trans_baseline
# do
#     o=${out}/models/$x
#     jobfile=${out}/jobs/$x/fusion_job_${i}.sh
#     mkdir -p $o
#     mkdir -p ${out}/jobs/$x

#     echo "g=$g" > $jobfile
#     #ciseqtl
#     printf "Rscript /home/i3gupta/tools/fusion_twas-master/FUSION.compute_weights.R --bfile ${out}/cissnps/$x/$g --covar ${out}/covars/combined.covars --out ${o}/${g} --tmp ${o}/${g}.tmp --models lasso,enet --pheno ${out}/gene_phen/${g}.phen --verbose 2 --PATH_gcta /home/i3gupta/tools/fusion_twas-master/gcta_nr_robust --PATH_gemma /home/i3gupta/tools/gemma-0.98.5-linux-static-AMD64 --save_hsq --hsq_p 1.00 &> ${o}/${g}.log;\n" >> $jobfile
# done ) &

# i=$(($i+1))
# done

wait 
exit

