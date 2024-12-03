gt="/home/i3gupta/lustre/DSC291/data/geuvadis_hm3"
ge="/home/i3gupta/lustre/DSC291/data/geuvadis_gene_expression.csv"

out="/home/i3gupta/lustre/DSC291/data/out"

genes="/home/i3gupta/lustre/DSC291/data/geuvadis_gene_info.csv" # gene info
x=`basename $ge`

################################################################################################
# Gene Phen files
################################################################################################



################################################################################################
# Genetic PCs
################################################################################################

# rsq=0.8 # r2 threshold
# N=50 # number of variants in a widnow
# w=5 

# o=${out}/genetic_PCs/N${N}_w${w}_rsq${rsq}
# mkdir -p $out/genetic_PCs

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


################################################################################################
# # Combine covariates
################################################################################################

# python /home/i3gupta/scripts/combine_covars.py -g /home/i3gupta/lustre/lupus/pbcounts/genetic_PCs/N50_w5_rsq0.8.eigenvec -x /home/i3gupta/lustre/lupus/pbcounts/gene_exp_PCs/${x}.eigenvec -o /home/i3gupta/lustre/lupus/pbcounts/covars/${x}.covars

################################################################################################
# # cis snps
################################################################################################


mkdir -p $out/cissnps/baseline
i=0
while IFS=$',' read -r TargetID Gene_Symbol Chr Coord; do
    if [ "$i" -gt 1 ]; then
        # Remove 'chr' prefix from chromosome value if present
        chrom=$(echo "$Chr" | sed 's/chr//g')
        
        # Calculate start and end positions with the 250,000 base pair buffer
        from_bp=$((Coord - 250000))
        to_bp=$((Coord + 250000))
        
        # Remove everything after the first dot in the output name
        TargetID=$(echo "${TargetID}" | cut -d '.' -f 1)
        
        # Run the PLINK command with the extracted values
        plink --bfile $gt --chr "$chrom" --from-bp "$from_bp" --to-bp "$to_bp" --make-bed --out "${out}/cissnps/baseline/${TargetID}"
    fi
    i=$(($i+1))
done < "$genes"

################################################################################################
# # Make job files (one for each gene)
################################################################################################

# i=0
# for g_f in `ls ${out}/gene_phen/`
# do 

# g=`echo $g_f | sed 's/.phen//g' `
# out="${out}/models/${g}"
# jobfile=${out}/jobs/fusion_job_${i}.sh

# mkdir -p /home/i3gupta/lustre/lupus/pbcounts/jobs/$celltype
# mkdir -p $out

# (echo "g=$g" > $jobfile

# for x in cases controls donors # here we'll have bins
# do 
#     mkdir -p $out/$x
#     #ciseqtl
#     printf "Rscript /home/i3gupta/tools/fusion_twas-master/FUSION.compute_weights.R --bfile ~/lustre/lupus/pbcounts/cissnps/$g --covar /home/i3gupta/lustre/lupus/pbcounts/covars/${celltype}_${x}.covars --out $out/$x/${g} --tmp $out/$x/${g}.tmp --models top1,blup,lasso,enet --pheno /home/i3gupta/lustre/lupus/pbcounts/gene_phen/${celltype}/$x/${g}.phen --verbose 2 --PATH_gcta /home/i3gupta/tools/fusion_twas-master/gcta_nr_robust --PATH_gemma /home/i3gupta/tools/gemma-0.98.5-linux-static-AMD64 --save_hsq --hsq_p 1.00 &> $out/$x/${g}.log;\n" >> $jobfile
#     #gw-eqtl
#     # printf "Rscript /home/i3gupta/tools/fusion_twas-master/FUSION.compute_weights.R --bfile /home/i3gupta/lustre/lupus/imputed/LupusHRC.plink/lupusHRC_hm3_consensus_sumstats_info_0.3_maf_0.05 --covar /home/i3gupta/lustre/lupus/pbcounts_mean_log_filtered/${celltype}_${x}.covars --out $out/$x/${g} --tmp $out/$x/${g}.tmp --models top1,blup,lasso,enet --pheno /home/i3gupta/lustre/lupus/pbcounts_mean_log_filtered/gene_phen/${celltype}/$x/${g}.csv --verbose 2 --PATH_gcta /home/i3gupta/tools/fusion_twas-master/gcta_nr_robust --PATH_gemma /home/i3gupta/tools/gemma-0.98.5-linux-static-AMD64 --save_hsq --hsq_p 1.00 &> $out/$x/${g}.log;\n" >> $jobfile
# done ) &

# printf "Rscript /home/i3gupta/tools/fusion_twas-master/FUSION.compute_weights.R --bfile ~/lustre/lupus/pbcounts/cissnps/$g --covar /home/i3gupta/lustre/lupus/pbcounts/covars/${celltype}_${x}.covars --out $out/$x/${g} --tmp $out/$x/${g}.tmp --models top1,blup,lasso,enet --pheno /home/i3gupta/lustre/lupus/pbcounts/gene_phen/${celltype}/$x/${g}.phen --verbose 2 --PATH_gcta /home/i3gupta/tools/fusion_twas-master/gcta_nr_robust --PATH_gemma /home/i3gupta/tools/gemma-0.98.5-linux-static-AMD64 --save_hsq --hsq_p 1.00 &> $out/$x/${g}.log;\n" >> $jobfile

# i=$(($i+1))
# done

# wait 
# exit

