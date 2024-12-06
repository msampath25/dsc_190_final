
bindir="$1"
output_file="bins_snps_data.txt"  

> "$output_file"

bim_files=($(ls "$bindir"/*.bim))
for file in "${bim_files[@]}"
do
    lines=$(wc -l < "$file")
    actual_lines=$((lines - 1))
    echo -e "$(basename "$file")\t$actual_lines" >> "$output_file"
done