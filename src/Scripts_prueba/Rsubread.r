#Script para generar la matrix de conteo a traves de Rsubread 

#cargamos el paquete Rsubread 
library(Rsubread) 

bam.files<-dir(path="../data/", pattern= *.sort.bam, recursive = TRUE, full.names = TRUE) 
gtf.file<-dir(path="../data/", pattern= *.gff, recursive = TRUE, full.names = TRUE)
count.table <- featureCounts(bam.files, annot.inbuilt=gtf.file)

counts_df <- data.frame(GeneID = count.table$annotation$GeneID,
                        count.table$counts) 

write.table(counts_df,
            file = "counts_matrix.tsv",
            sep = "\t",
            quote = FALSE,
            row.names = FALSE)
