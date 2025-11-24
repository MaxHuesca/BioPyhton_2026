"""
Script for the automatization of SRR files download 


"""

#!/usr/bin/env bash 
set -e
set -u
set -o pipefail 


#check de arguments 
if [ "$#" -lt 1 ] # are there less than 1 argument
then
    echo "error: too few arguments, you provided $#, 3 required"
    echo "usage: script.sh arg1 arg2 arg3"
    exit 1
else 
    while [[ $# -gt 0 ]]; do
        case $1 in 
        -1|--illu1) ilu_1="$2"; shift 2 ;; 
        -2|--illu2) ilu_2="$2"; shift 2 ;;  
        -a|--adapters) adapters="$2"; shift 2 ;;
        -i|--inicio) inicio="$2"; shift 2 ;;
        -f|--fin) fin="$2"; shift 2;;
        *) echo "Opción desconocida: $1"; exit 1 ;; 
    esac
done



#activate the python enviroment with the tools 
conda activate sra-tools 

#Direcotry to store the data 
output_dir = "../data/" 

#if the directory doesnt exist we make one 
if !(-d $output_dir)
then 
    mkdir $output_dir 

#Obtain de SRR files in .srr format 
prefetch --output-directory $output_dir $SRR_1 
prefetch --output-directory $output_dir $SRR_2
