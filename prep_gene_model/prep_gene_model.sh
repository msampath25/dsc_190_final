gt="/home/i3gupta/lustre/DSC291/data/geuvadis_hm3"
ge="/home/i3gupta/lustre/DSC291/data/geuvadis_gene_expression.csv"

out="/home/i3gupta/lustre/DSC291/data/out"

genes="/home/i3gupta/lustre/DSC291/data/geuvadis_gene_info.csv" # gene info
x=`basename $ge`

SCRIPT_DIR=$(dirname "$(realpath "$0")")

################################################################################################
# Gene Phen files
################################################################################################

# python $SCRIPT_DIR/gene_phen.py $ge $out/gene_phen

################################################################################################
# Genetic PCs
################################################################################################

rsq=0.8 # r2 threshold
N=50 # number of variants in a widnow
w=5 

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
# # cis snps
################################################################################################


# mkdir -p $out/cissnps/baseline
# i=0
# while IFS=$',' read -r TargetID Gene_Symbol Chr Coord; do
#     if [ "$i" -gt 1 ]; then
#         # Remove 'chr' prefix from chromosome value if present
#         chrom=$(echo "$Chr" | sed 's/chr//g')
        
#         # Calculate start and end positions with the 250,000 base pair buffer
#         from_bp=$((Coord - 250000))
#         to_bp=$((Coord + 250000))
        
#         # Remove everything after the first dot in the output name
#         TargetID=$(echo "${TargetID}" | cut -d '.' -f 1)
        
#         # Run the PLINK command with the extracted values

#         (plink --bfile $gt --chr "$chrom" --from-bp "$from_bp" --to-bp "$to_bp" --make-bed --out "${out}/cissnps/baseline/${TargetID}")&
#     fi
#     i=$(($i+1))
# done < "$genes"

################################################################################################
# # Make job files (one for each gene)
################################################################################################

i=0
for g_f in `ls ${out}/gene_phen/`
do 
g=`echo $g_f | sed 's/.phen//g' `

(
for x in baseline # here we'll have baseline, trans, bins
do 
    o=${out}/models/$x
    jobfile=${out}/jobs/$x/fusion_job_${i}.sh
    mkdir -p $o
    mkdir -p ${out}/jobs/$x

    echo "g=$g" > $jobfile
    #ciseqtl
    printf "Rscript /home/i3gupta/tools/fusion_twas-master/FUSION.compute_weights.R --bfile ${out}/cissnps/$x/$g --covar ${out}/covars/combined.covars --out ${o}/${g} --tmp ${o}/${g}.tmp --models top1,blup,lasso,enet --pheno ${out}/gene_phen/${g}.phen --verbose 2 --PATH_gcta /home/i3gupta/tools/fusion_twas-master/gcta_nr_robust --PATH_gemma /home/i3gupta/tools/gemma-0.98.5-linux-static-AMD64 --save_hsq --hsq_p 1.00 &> ${o}/${g}.log;\n" >> $jobfile
done ) &

i=$(($i+1))
done

wait 
exit

