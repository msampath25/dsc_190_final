gt="/home/i3gupta/lustre/DSC291/data/geuvadis_hm3"
ge="/home/i3gupta/lustre/DSC291/data/geuvadis_gene_expression.csv"

out="/home/i3gupta/lustre/DSC291/data/out"

genes="/home/i3gupta/lustre/DSC291/data/geuvadis_gene_info_sub.csv" # gene info
x=`basename $ge`

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

# python $SCRIPT_DIR/combine_covars.py -g $out/covars/N${N}_w${w}_rsq${rsq}.eigenvec -x $out/covars/genexp_PCs.eigenvec -o $out/covars/combined.covars

################################################################################################
# Get chromosome-wise genotypes
################################################################################################

# for chrom in {1..22}; do
#         chromf="${out}/cissnps/chromwide/${chrom}"
#         if [ ! -f $chromf ]; then
#             plink --bfile $gt --chr "$chrom" --make-bed --out $chromf
#         fi
# done

################################################################################################
# Filter chromosome-wise eqtl p-values
################################################################################################

for chrom in {1..22}; do
    bfile=${out}/cissnps/chromwide/${chrom}
    covar=$out/covars/combined.covars
    Rscript $SCRIPT_DIR/matrixeqtl.R --bfile $bfile --gene $ge --covar $covar --out $out/cissnps/chromwide_${chrom}_eqtls_allgenes.tsv --pval 1e-3
done

for gene in `cat /home/i3gupta/lustre/DSC291/data/genes.txt`; do
    $out/cissnps/chromwide_${chrom}_eqtls_allgenes.tsv
done
################################################################################################
# # Make FUSION job files (one for each gene) using chromosome-wide genotypes
################################################################################################


# mkdir -p $out/cissnps/chromwide
# i=0
# while IFS=$',' read -r TargetID Gene_Symbol Chr Coord; do
#     if [ "$i" -gt 1 ]; then
#         # Remove 'chr' prefix from chromosome value if present
#         chrom=$(echo "$Chr" | sed 's/chr//g')
        
#         # Remove everything after the first dot in the output name
#         TargetID=$(echo "${TargetID}" | cut -d '.' -f 1)

#         (
#         for x in chromwide
#         do 
#             o=${out}/models/$x
#             jobfile=${out}/jobs/$x/fusion_job_${i}.sh
#             mkdir -p $o
#             mkdir -p ${out}/jobs/$x

#             echo "g=$g" > $jobfile
#             printf "Rscript /home/i3gupta/tools/fusion_twas-master/FUSION.compute_weights.R --bfile $chromf --covar ${out}/covars/combined.covars --out ${o}/${g} --tmp ${o}/${g}.tmp --models top1,lasso,enet --pheno ${out}/gene_phen/${g}.phen --verbose 2 --PATH_gcta /home/i3gupta/tools/fusion_twas-master/gcta_nr_robust --PATH_gemma /home/i3gupta/tools/gemma-0.98.5-linux-static-AMD64 --save_hsq --hsq_p 1.00 &> ${o}/${g}.log;\n" >> $jobfile
#         done ) &

#     fi
#     i=$(($i+1))
# done < "$genes"

# wait
# exit

