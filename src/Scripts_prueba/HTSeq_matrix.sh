#!/bin/bash
set -e # Only to ensure scrpt executions
set -u # To avoid undefined variables usage
set -o pipefail # To avoid failed runs

#Script para hacer una matriz de conteos con HTSeq 

#Argumentos: 
#   $1: especificar path con los bam files
#   $2: path archivo GTF

if [[ $# < 1 ]]: 
    echo "No se especifico los argumentos necesarios para realizar la matriz "
    exit 1
fi 

path=$1 
gtf_file=$2 
out_dir="$path"/../Htseq

conda activate /home/ismadlsh/.conda/envs/bio_informatics

for bam_file in "$path"/*sort.bam ; do  
    id=$(basename ${bam_file%%.*}) 
    htseq-count -f bam -r pos -c $out_dir/"$id"_counts.txt $bam_file
done 



