#!/bin/bash
# Script originally made by Marco Sanchez, moved and modified by Ishaan Gupta for running
# Input directories and output directory
cissnps_dir="$1"
regions_dir="$2"
output_dir="$3"

mkdir -p "${output_dir}"

# Loop through each gene file
for cissnps_file in "${cissnps_dir}"/*.bed; do
    gene_name=$(basename "${cissnps_file}" .bed)

    echo "Processing cis-SNPs for gene: ${gene_name}"

    # Loop through each BED file
    for bed_file in "${regions_dir}"/*.bed; do
        region_name=$(basename "${bed_file}" .bed)

        output_prefix="${output_dir}/${gene_name}_${region_name}"

        echo "    Extracting regions from ${region_name} for ${gene_name}..."

        # Run PLINK with `--extract range`
        plink --bfile "${cissnps_dir}/${gene_name}" \
               --extract range "${bed_file}" \
               --make-bed \
               --out "${output_prefix}"
    done
done

echo "All processing is complete. Outputs saved to ${output_dir}."
