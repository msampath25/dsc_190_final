#!/bin/bash

cissnps_dir="$1"
bed_files_dir="$2"
output_dir="$3"

mkdir -p "${output_dir}"

# Loop through each gene's genotype in the cis-SNPs folder
for gene_file in "${cissnps_dir}"/*.bed; do
    gene_name=$(basename "${gene_file}" .bed)

    echo "Processing gene: ${gene_name}"

    # Loop through each bed file in the bed files directory
    for bed_file in "${bed_files_dir}"/*.bed; do
        bed_name=$(basename "${bed_file}" .bed)

        output_prefix="${output_dir}/${gene_name}_${bed_name}"

        echo "    Filtering ${gene_name} against ${bed_name}..."

        plink --bfile "${gene_file%.bed}" \
              --extract "${bed_file%.bed}.bim" \
              --make-bed \
              --out "${output_prefix}"
    done
done

echo "Filtering completed. Filtered files saved in ${output_dir}."
