#!/usr/bin/env bash 
set -e
set -u
set -o pipefail 
#This program make the fastqc reports of SRR files provided on a path 
#Arguments 
#   $1: path with the data 
#   $2: optional argument, specifies the output dir 


# Check that a path argument was provided
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <path_to_fastq_data>"
    exit 1
fi
data_path="$1"


#if the user specified a output dir 
if [[ -n $2 ]]; then 
    output_dir=$2 
else 
    output_dir="$data_path"../../results/fastqc
fi 

#make the output dir
mkdir -p $output_dir

# Run FastQC on all FASTQ files in the directory
fastqc -t 4 -o "$output_dir" "$data_path"/*fastq*
 