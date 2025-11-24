#!/usr/bin/env bash 

set -e
set -u
set -o pipefail  


#la path pasada a este script debe ser donde estan contenidos los archivos SRR_clean ie /export/storage/users/ismadlsh/LCG/S3/bio_python/prueba_1_babesia/data/SRR/clean/
path=$1 

out_dir= "${path/clean/BAM}"

#indexar el genoma 
[[ -f ../data/genome/*fna.gz ]] && bwa index -p index_genome ../data/genome/*fna.gz > "$out_dir"

#creamos una carpeta para guardar las lectruas procesadas
[[ ! -d "$out_dir" ]] && mkdir "$out_dir" 

#recorremos los archivos en el path que esten limpios
for SRR in "$path";do   
    #verificar si se trata de un paired (terminacion .fastq.gz) 
        #obtener el nombre del archivo 1 y del 2 (paired )
        #correr BWA con ambos archivos  
    #si no es paired hacemos el BWA para un archivo single 

    #activamos el entorno de conda con las librerias 
    conda activate /home/ismadlsh/.conda/envs/bio_informatics
    #transformamos el archivo SAM en BAM con SRA tools 
done