folder1="/home/i3gupta/lustre/DSC291/data/out/cissnps/baseline"
folder2="/home/i3gupta/lustre/DSC291/data/out/cissnps/cis_epi"
out="/home/i3gupta/lustre/DSC291/data/out/cis_snpcounts_gene_by_bin.csv"
# Define the suffixes
suffixes=("000" "001" "010" "011" "100" "101" "110" "111")

# Create the output table
echo -e "Prefix\tBaseline\t000\t001\t010\t011\t100\t101\t110\t111" > $out

# Iterate over .bim files in folder1
for file1 in "$folder1"/*.bim; do
    # Extract the prefix from the filename
    prefix=$(basename "$file1" .bim)
    if [ -f /home/i3gupta/lustre/DSC291/data/out/models/baseline/${prefix}.log ]; then
        # Count the number of lines in the baseline file
        baseline_count=$(wc -l < "$file1")
        
        # Initialize an array to hold the counts for the 8 suffix files
        counts=()
        
        # Iterate over the suffixes
        for suffix in "${suffixes[@]}"; do
            # Construct the filename for the second folder
            file2="$folder2/${prefix}_${suffix}.bim"
            
            # Check if the file exists and count lines, otherwise use 0
            if [[ -f "$file2" ]]; then
                line_count=$(wc -l < "$file2")
            else
                line_count=0
            fi
            
            # Add the count to the array
            counts+=("$line_count")
        done
        
        # Write the row to the output table
        echo -e "$prefix\t$baseline_count\t${counts[*]}" | sed 's/ /\t/g' >> $out
    fi
done