#!/bin/bash

# Directories and paths
bed_file="/Users/marcosanchez/DSC 190 project/out/cissnps/epi/ENSG00000000419"
out_dir="/Users/marcosanchez/DSC 190 project/out/cissnps/epi"
genes="/Users/marcosanchez/DSC 190 project/geuvadis_gene_info.csv"

mkdir -p "${out_dir}"

buffer=250000

# Loop through genes from the gene info file
i=0
while IFS=',' read -r TargetID Gene_Symbol Chr Coord; do
    if [ "$i" -gt 0 ]; then
        chrom=$(echo "$Chr" | sed 's/chr//g')

        from_bp=$((Coord - buffer))
        to_bp=$((Coord + buffer))

        [ "$from_bp" -lt 0 ] && from_bp=0

        output_prefix="${out_dir}/${TargetID}"
        echo "Processing ${TargetID} on chromosome ${chrom} from ${from_bp} to ${to_bp}..."

        plink --bfile "${bed_file}" \
              --chr "${chrom}" \
              --from-bp "${from_bp}" \
              --to-bp "${to_bp}" \
              --make-bed \
              --out "${output_prefix}"
    fi
    i=$((i + 1))
done < "${genes}"

echo "Processing completed."
