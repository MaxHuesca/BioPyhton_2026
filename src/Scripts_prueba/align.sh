#!/bin/bash

#Programa que hace el alineamiento de los archivos de secuenciacion para generar los archivos bam
#Argumentos 
#   $1:path con los archivos clean SRR
#   $2:path con el genoma de referencia
#   $3:argumento opcional con el archivo gtf
#   $4:argumento opcional para especificar el path de salida 

# Check that a path argument was provided
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <path_to_fastq_data>"
    exit 1
fi
path="$1"


#if the user specified a output dir 
if [[ -n $4 ]]; then 
    output_dir=$4 
else 
    output_dir="$path"/../aligned
fi 

mkdir -p $output_dir

genome=$2

log="$output_dir/alignments.log"
#creamos el archivo temporal para el log del programa 
touch "$log"

#creamos el index del genoma 
index=$(basename ${genome%%.*})_index 
#hacemos la indexacion del genoma
bwa index -p $index $genome 

# Array para controlar archivos ya procesados
declare -A processed

for archivo in "$path"/*.fastq.gz; do
    # Obtener nombre base
    filename=$(basename "$archivo" .fastq.gz)

    # Extraer ID base (sin _1, _2 o _clean)
    base_id=$(echo "$filename" | sed 's/_1_clean$//; s/_2_clean$//; s/_clean$//; s/_1$//; s/_2$//') # Gracias Vinuesa por

    # Si ya se procesó, se salta
    if [[ ${processed["$base_id"]:-} == "yes" ]]; then
        continue
    fi

    echo "Procesando $base_id" >> "$log"

    # Definir potenciales archivos de input
    archivo_1="${path}/${base_id}_1_clean.fastq.gz"
    archivo_2="${path}/${base_id}_2_clean.fastq.gz"
    archivo_single="${path}/${base_id}_clean.fastq.gz"

    # Verificar cuál es el que existe
    if [[ -f "$archivo_1" && -f "$archivo_2" ]]; then
        # Caso en que es paired-end
        output="${output_dir}/${base_id}.sam"
        echo "Alineando paired-end $base_id" >> "$log"
        bwa mem -o "$output" "$index" "$archivo_1" "$archivo_2"

    elif [[ -f "$archivo_single" ]]; then
        # Caso en el que es single-end
        output="${output_dir}/${base_id}.sam"
        echo "Alineando single-end: $base_id" >> "$log"
        bwa mem -o "$output" "$index" "$archivo_single"

    else
        echo "ERROR: No se encontraron archivos para $base_id" >> "$log"
        continue
        fi
    # Marcar como procesado
    processed["$base_id"]="yes"
    echo "Completado: $output" >> "$log"
done

echo "Alineamientos completos" >> "$log"
#borramos los archivos con los genomas indexados 
rm -rf "$index"* 


echo -e "Conversión de archivos SAM a BAM y ordenado\nDirectorio: $path\n" >> "$log"

# Iterar sobre el directorio especificado
for sam_file in "$output_dir"/*.sam; do
    base_name="${sam_file%.sam}" # Obtenemos el nombre sin la extensión
    echo "Procesando: $sam_file" >> "$log"

    # Conversión a BAM y sorteo
    samtools view -b "$sam_file" | samtools sort -o "${base_name}.sort.bam" && rm "$sam_file" # Sólo se remueve si la conversión salió bien
    echo "Archivo $sam_file convertido a y ordenado" >> "$log"
done 

output_tables="$output_dir"/../tables 
mkdir -p $output_tables

if [[ -n $3 ]]; then 
    echo "Se especifico un archivo gff, iniciando la obtencion de las tablas" >> $log
    gff=$3
    for bam_file in "$output_dir"/*.sort.bam; do
        base_name=$(basename $bam_file) # Eliminamos el sufijo '.sort.bam'
        count_file="${base_name%%.*}.count.txt"
        echo "Obteniendo tabla $count_file de la muestra $base_name" >> $log
    
        echo "Procesando: $bam_file" >> "$log"
        coverageBed -a "$gff" -b "$bam_file" > "$output_tables"/"$count_file"
    done 
fi

echo "Conteo de archivos completo" >> "$log"
