#!/bin/bash

# 000: Regions unique to all genome without annotations
bedtools intersect -a dummy.bed \
    -b B_cell_blood_enhancers.bed.txt B_cell_atac.bed B_cell_contact_domains.bedpe \
    -v > 000.bed

# 001: Regions unique to contact domains
bedtools intersect -a B_cell_contact_domains.bedpe \
    -b B_cell_atac.bed B_cell_blood_enhancers.bed.txt \
    -v > 001.bed

# 010: Regions unique to ATAC
bedtools intersect -a B_cell_atac.bed \
    -b B_cell_contact_domains.bedpe B_cell_blood_enhancers.bed.txt \
    -v > 010.bed

# 100: Regions unique to enhancers
bedtools intersect -a B_cell_blood_enhancers.bed.txt \
    -b B_cell_contact_domains.bedpe B_cell_atac.bed \
    -v > 100.bed

# 011: Regions in ATAC and contact domains but not enhancers
bedtools intersect -a B_cell_atac.bed \
    -b B_cell_contact_domains.bedpe > 011_int.bed

bedtools intersect -a 011_int.bed \
    -b B_cell_blood_enhancers.bed.txt \
    -v > 011.bed
rm 011_int.bed

# 110: Regions in enhancers and ATAC but not contact domains
bedtools intersect -a B_cell_blood_enhancers.bed.txt \
    -b B_cell_atac.bed > 110_int.bed
bedtools intersect -a 110_int.bed \
    -b B_cell_contact_domains.bedpe \
    -v > 110.bed
rm 110_int.bed

# 101: Regions in enhancers and contact domains but not ATAC
bedtools intersect -a B_cell_blood_enhancers.bed.txt \
    -b B_cell_contact_domains.bedpe > 101_int.bed
bedtools intersect -a 101_int.bed \
    -b B_cell_atac.bed \
    -v > 101.bed
rm 101_int.bed

# 111: Regions common to all three
bedtools intersect -a B_cell_blood_enhancers.bed.txt \
    -b B_cell_contact_domains.bedpe B_cell_atac.bed > 111.bed