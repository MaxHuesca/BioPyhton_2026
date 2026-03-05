#!/bin/bash
set -euo pipefail

#Program to make the counts tables with bam files and gff file
#Arguments 
#   $1: path with the bam files
#   $2: path with the gff file

path=$1 
gff=$2 

output_dir="$path/../tables"

log="$output_dir/run_coverageBed.log"
touch $log

echo -e "Running coverageBed\nPath: $path" > "$log"
mkdir -p "$output_dir"


# loop to search into all the bam files
for bam_file in "$path"/*.sort.bam; do
    name="${bam_file%.sort.bam}"
    base_name=$(basename "$name")
    count_file="${base_name}.count.txt"

    echo "Proccesing: $bam_file" >> "$log"
    coverageBed -a "$gff" -b "$bam_file" > "$output_dir$count_file"
done

echo "Tables generated on $output_dir" >> "$log"