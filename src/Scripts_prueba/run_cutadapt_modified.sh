#!/usr/bin/env bash 

set -e
set -u
set -o pipefail  

#Programa que hace la limpieza de los datos crudos de secuenciación con el programa cut adapt 
#Argumentos 
#      $1:path con los directorios de los datos crudos de secuenciacion
#      $2: argumento opcional para especificar el path de salida


# Check that a path argument was provided
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <path_to_fastq_data>"
    exit 1
fi
path="$1"


#if the user specified a output dir 
if [[ -n $2 ]]; then 
    output_clean=$2 
else 
    output_clean="$path"/../../results/clean
fi 

mkdir -p $output_clean

log="$output_clean"/clean.log

#iteramos sobre cada archivo fastq
shopt -s nullglob

echo "Iniciando la limpiezad de los archivos SRR en $path" >> $log
for SRR in "$path"/*.fastq.gz; do
#verificamos no sea el archivo correspondiente a una lectura pareada
	if [[ "$SRR" != *_2.fastq.gz ]];then
              archivo_1=$SRR
              output_1="$(basename "${archivo_1/.fastq.gz/_clean.fastq.gz}")" #basename se utiliza para solo usar el ultimo nombre en la path absoluta
              #revisamos si se tratan de lecturas pareadas
              if [[ "$SRR" == *_1.fastq.gz ]];then
                     #asignamos los nombre de los archivos de entrada y salida
                     archivo_2="${SRR/_1.fastq.gz/_2.fastq.gz}"
                     output_2="$(basename "${archivo_2/_2.fastq.gz/_2_clean.fastq.gz}")"
                     #realizamos el trimeo con cutadapt
                     echo "Limpiando archivos pareados de ${SRR##/*} salida $output_1 $output_2"
                     cutadapt -m 25 -q 20 -o "$output_clean"/"$output_1" -p "$output_clean"/"$output_2" $archivo_1 $archivo_2 #explorar la idea de usar qsub con un script externo como vero
              else
                     echo "Limpiando archivo no pareado de ${SRR##/*} salida $output_1"
                     #se corre el cut adapt con un solo archivo (single end)
                     cutadapt -m 25 -q 20 -o "$output_clean"/"$output_1" $archivo_1
              fi
       fi
done
