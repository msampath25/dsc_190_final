#!/bin/bash

cd /home/i3gupta/lustre/DSC291/data/regions

for x in B_cell_blood_enhancers.bed.txt B_cell_atac.bed B_cell_contact_domains.bed; do
awk '{print $1, $2, $3}' $x | sed 's/ /\t/g' | grep -v chrX | grep -v chrY | bedtools sort -i > $(echo $x | sed 's/.bed/_sorted.bed/g' )
x=$(echo $x | sed 's/.bed/_sorted.bed/g' )
bedtools complement -i $x -g hg19.genome > $(echo $x | sed 's/.bed/_cmpl.bed/g' )
done

# 000: Regions unique to all genome without annotations
bedtools intersect -a B_cell_blood_enhancers_sorted_cmpl.bed.txt \
    -b  B_cell_atac_sorted_cmpl.bed > tmp.bed 
bedtools intersect -a B_cell_contact_domains_sorted_cmpl.bed -b tmp.bed \
    | awk '{print $1, $2, $3, "0", "0", "+"}' > bins/000.bed

# 001: Regions unique to contact domains
bedtools intersect -a B_cell_blood_enhancers_sorted_cmpl.bed.txt \
    -b  B_cell_atac_sorted_cmpl.bed > tmp.bed 
bedtools intersect -a B_cell_contact_domains_sorted.bed -b tmp.bed \
    | awk '{print $1, $2, $3, "0", "0", "+"}' > bins/001.bed

# 010: Regions unique to ATAC
bedtools intersect -a B_cell_blood_enhancers_sorted_cmpl.bed.txt \
    -b  B_cell_atac_sorted.bed > tmp.bed 
bedtools intersect -a B_cell_contact_domains_sorted_cmpl.bed -b tmp.bed \
    | awk '{print $1, $2, $3, "0", "0", "+"}' > bins/010.bed

# 100: Regions unique to enhancers
bedtools intersect -a B_cell_blood_enhancers_sorted.bed.txt \
    -b  B_cell_atac_sorted_cmpl.bed > tmp.bed 
bedtools intersect -a B_cell_contact_domains_sorted_cmpl.bed -b tmp.bed \
    | awk '{print $1, $2, $3, "0", "0", "+"}' > bins/100.bed

# 011: Regions in ATAC and contact domains but not enhancers
bedtools intersect -a B_cell_blood_enhancers_sorted_cmpl.bed.txt \
    -b  B_cell_atac_sorted.bed > tmp.bed 
bedtools intersect -a B_cell_contact_domains_sorted.bed -b tmp.bed \
    | awk '{print $1, $2, $3, "0", "0", "+"}' > bins/011.bed

# 110: Regions in enhancers and ATAC but not contact domains
bedtools intersect -a B_cell_blood_enhancers_sorted.bed.txt \
    -b  B_cell_atac_sorted.bed > tmp.bed 
bedtools intersect -a B_cell_contact_domains_sorted_cmpl.bed -b tmp.bed \
    | awk '{print $1, $2, $3, "0", "0", "+"}' > bins/110.bed

# 101: Regions in enhancers and contact domains but not ATAC
bedtools intersect -a B_cell_blood_enhancers_sorted.bed.txt \
    -b  B_cell_atac_sorted_cmpl.bed > tmp.bed 
bedtools intersect -a B_cell_contact_domains_sorted.bed -b tmp.bed \
    | awk '{print $1, $2, $3, "0", "0", "+"}' > bins/101.bed

# 111: Regions common to all three
bedtools intersect -a B_cell_blood_enhancers_sorted.bed.txt \
    -b  B_cell_atac_sorted.bed > tmp.bed 
bedtools intersect -a B_cell_contact_domains_sorted.bed -b tmp.bed \
    | awk '{print $1, $2, $3, "0", "0", "+"}' > bins/111.bed

rm tmp.bed