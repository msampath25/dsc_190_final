#!/bin/bash
# Script originally made by Marco Sanchez, moved and modified by Ishaan Gupta for running
# Directories and paths
beds_dir="/home/i3gupta/lustre/DSC291/data/regions/bins"
original_gt_dir="/home/i3gupta/lustre/DSC291/data/out/cissnps/trans_baseline"
out_dir="/home/i3gupta/lustre/DSC291/data/out/cissnps/trans_epi"
out="/home/i3gupta/lustre/DSC291/data/out"

################################################################################################
# # Bin the SNPs by epigenetic info
################################################################################################

mkdir -p "${out_dir}"
SCRIPT_DIR=$(dirname "$(realpath "$0")")
$SCRIPT_DIR/../filter_gene_cissnps.sh ${original_gt_dir} $beds_dir ${out_dir}
echo "Processing completed."


################################################################################################
# # Make job files (one for each gene)
################################################################################################


# i=0
# for g in `cat $out/genes_with_transeqtls.txt`
# do

# (
# x=trans_epi
# jobfile=${out}/jobs/${x}/fusion_job_${i}.sh
# mkdir -p ${out}/jobs/${x}
# echo "g=$g" > $jobfile
# for bin in 000 001 010 011 100 101 110 111
# do
#     o=${out}/models/${x}_${bin}
#     mkdir -p $o

#     geno=${out}/cissnps/$x/${g}_${bin}
#     if [ -f $geno.bed ]; then
#         printf "Rscript /home/i3gupta/tools/fusion_twas-master/FUSION.compute_weights.R --bfile $geno --covar ${out}/covars/combined.covars --out ${o}/${g} --tmp ${o}/${g}.tmp --models lasso,enet --pheno ${out}/gene_phen/${g}.phen --verbose 2 --PATH_gcta /home/i3gupta/tools/fusion_twas-master/gcta_nr_robust --PATH_gemma /home/i3gupta/tools/gemma-0.98.5-linux-static-AMD64 --save_hsq --hsq_p 1.00 &> ${o}/${g}.log;\n" >> $jobfile
#     fi
# done
# ) &

# i=$(($i+1))
# done


# wait 
# exit

