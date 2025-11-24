#!/bin/bash 
set -e
set -u
set -o pipefail 

#Programa que hace la matriz de conteo 
#Argumentos
#   $1: path con las tablas creadas por un programa de cuantificacion coveragedBed en este caso
#   $2: optional argument, specifies the output dir 


# Check that a path argument was provided
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <path_to_fastq_data>"
    exit 1
fi
path="$1" ## Path donde se tienen los *.count.txt


#if the user specified a output dir 
if [[ $# > 2 ]]; then 
    output_dir=$2
else 
    output_dir=$1
fi 

#make the output dir
mkdir -p $output_dir

log="$output_dir/matrixes.log"
echo -e "Generación de matrices\nDirectorio: $path" > "$log"

# Lista de IDs de genes únicos, a partir de todos los archivos (los samples)
for file in "$path"/*.count.txt; do
    awk -F'\t' '{
        split($9, col9, ";"); # Arreglo con los campos que hay en la novena columna
        id = ""; name = ""; # Vacíos al inicio
        for (i in col9) {
	    # Quitar el prefijo si lo hay
            if (col9[i] ~ /^ID=/) id = substr(col9[i], 4);
            if (col9[i] ~ /^Name=/) name = substr(col9[i], 6);
        }
        if (id != "") print id "\t" name;
    }' "$file"
done | sort -u > "$output_dir/all_genes_with_names.txt"

# Generación de matriz de ids vs samples
echo "Haciendo matriz de reads..." >> "$log"

out_matrix="$output_dir/final_count_matrix.tsv"

echo -ne "GeneID\tGeneName" > "$out_matrix"
# Creación del encabezado completo
for file in "$path"/*.count.txt; do
    sample=$(basename "$file" .count.txt)
    echo -ne "\t$sample" >> "$out_matrix"
done
echo "" >> "$out_matrix" # Sólo para añadir un salto de línea 

#este ciclo while ira leyendo todos los genes previamente guardados
while IFS=$'\t' read -r gen_id name; do 
    # Imprimimos el ID
    echo -ne "$gen_id\t" >> "$out_matrix"
    
    # Si no tiene nombre, imprimimos "--"
    if [[ -z "$name" ]]; then
        echo -ne "--" >> "$out_matrix"
    else
        echo -ne "$name" >> "$out_matrix"
    fi
    #recorremos todos las tablas disponibles de conteo 
    for file in "$path"/*.count.txt; do
        #obtenemos solo el id del gen 
        id=$gen_id
        #buscamos el id en la tabla correspondiente a la sample
        count_gene=$(grep -w "ID=$id" $file | cut -f10 ) 
        #si la encontro ponemos en la tabla su conteo 
        if [[ -n $count_gene ]]; then 
            echo -ne "\t${count_gene}" >> "$out_matrix"
        #si no asumimos que sun conteo es de 0 
        else 
            echo -ne "\t0" >> "$out_matrix"
        fi 
    done 
    #imprimimos un salto de linea 
    echo "" >> "$out_matrix"
done < "$output_dir/all_genes_with_names.txt"


echo "Matriz creada: $out_matrix" >> "$log"
