#!/bin/bash
set -euo pipefail
path=$1 # Path deseado
log="$path/run_coverageBed.log"
echo -e "Iniciando coverageBed\nPath: $path" > "$log"
mkdir -p "$path/../tables"

gff=$2 # dmel-all-r6.65.OnlyGenes.gff

# Iterar sobre el path indicado para hacer los conteos
for bam_file in "$path"/*.sort.bam; do
    name="${bam_file%.sort.bam}" # Eliminamos el sufijo '.sort.bam'
    base_name=$(basename "$name")
    count_file="${base_name}.count.txt"
    
    echo "Procesando: $bam_file" >> "$log"
    coverageBed -a "$gff" -b "$bam_file" > "$path"/../tables/"$count_file"
done

echo "Conteo de archivos completo" >> "$log"