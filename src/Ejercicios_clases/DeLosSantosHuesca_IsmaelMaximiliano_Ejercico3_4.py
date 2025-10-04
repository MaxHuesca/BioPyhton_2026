# Creacion de la clase gen con 3 atributos y 3 metodos 

import random 

# Creacion de la clase gen con 3 atributos y 3 metodos 

import random 

class Gen():  
    bases= {
        "A":"U", 
        "T":"A",
        "C":"G",
        "G":"C"
    }
    
    def __init__(self, Secuencia, cadena, inicio, fin, codificante):
        self.Secuencia="".join(Secuencia)
        self.cadena= cadena 
        self.start= inicio
        self.stop= fin
        self.codificante= codificante
        pass
    
    
    def transcribir(self, codon="none"): 
        if codon != "none":
            transcrito=codon.replace("T","U")
            return transcrito
        
        RNA=self.Secuencia
        if self.cadena=="foward": 
            RNA=RNA.replace("T","U")
            return RNA
        else: 
            for complemento in self.bases:
                RNA=RNA.replace(complemento, self.bases[complemento])      
            return RNA[::-1]
    
    #cambiar para que sea secuencia de RNA y no de DNA
    def marcos_lectura(self):
        transcrito=Gen.transcribir(self)
        codones= [transcrito[i:] for i in range(0,3)] 
        marcos=[[marco[pos:pos+3] for pos in range(0,round(len(marco)/3))] for marco in codones]
        
        return marcos 
                
    
    def GC(self):
        gc_content=(self.Secuencia.count("G")+self.Secuencia.count("C"))/len(self.Secuencia)*100
        return gc_content
    
    def longitud(self):
        return  len(self.Secuencia)
    
#Declaramos un gen aleatoriamente
lacY=Gen("ATCGTTTAAACGACTTTTACGGGGATTTACCCATTTTAGGCATTTTATCGATCGGGATCCACTGCATTACCCGCTACGCTTAGTCGATGCTGATCG", "reverse",20167,20263, True) 
#Realizamos sus metodos propios de la clase para obtener su informacion
lacY_RNA=lacY.transcribir()               
codones=lacY.marcos_lectura()
lac_Y_GC=lacY.GC()

print(f"El transcrito de lacY es {lacY_RNA}, sus codones lucen: {codones} y su contenido de GC es de: {lac_Y_GC}\n") 
#Cremaos dos subclases de ncRNA y tRNA

class tRNA(Gen): 
    
    def __init__(self, Secuencia, cadena, inicio, fin,anticodon,codificante=False):
        super().__init__( Secuencia, cadena, inicio, fin, codificante)
        self.anticodon=anticodon
    
    
    
    def transcribir(self):
        pre_RNA=list(super().transcribir())
        #asignamos las bases no canonicas en las posiciones standard
        pre_RNA[55]="P" 
        pre_RNA[15]="D"
        pre_RNA[20]="D"
        return "".join(pre_RNA)
        
        
    def estructura(self): 
        sec=list(self.transcribir())
        partes={ 
                "Acpetor-arm": "".join(sec[0:10]+(sec[65::])),
                "D-arm": "".join(sec[10:26]), 
                "Anticodon-arm": "".join(sec[26:45]),
                "Pseudo-loop": "".join(sec[46:49]),
                "Psi-arm":"".join(sec[49:65])
                }
        
        return partes
    
    
    def detectar_aa(self,codon):
         
        codigo_gen = {
            "phe": ["UUU", "UUC"],                         # Fenilalanina
            "leu": ["UUA", "UUG", "CUU", "CUC", "CUA", "CUG"],  # Leucina
            "ile": ["AUU", "AUC", "AUA"],                  # Isoleucina
            "met": ["AUG"],                                # Metionina (start)
            "val": ["GUU", "GUC", "GUA", "GUG"],           # Valina
            "ser": ["UCU", "UCC", "UCA", "UCG", "AGU", "AGC"],  # Serina
            "pro": ["CCU", "CCC", "CCA", "CCG"],           # Prolina
            "thr": ["ACU", "ACC", "ACA", "ACG"],           # Treonina
            "ala": ["GCU", "GCC", "GCA", "GCG"],           # Alanina
            "tyr": ["UAU", "UAC"],                         # Tirosina
            "his": ["CAU", "CAC"],                         # Histidina
            "gln": ["CAA", "CAG"],                         # Glutamina
            "asn": ["AAU", "AAC"],                         # Asparagina
            "lys": ["AAA", "AAG"],                         # Lisina
            "asp": ["GAU", "GAC"],                         # Ácido aspártico
            "glu": ["GAA", "GAG"],                         # Ácido glutámico
            "cys": ["UGU", "UGC"],                         # Cisteína
            "trp": ["UGG"],                                # Triptófano
            "arg": ["CGU", "CGC", "CGA", "CGG", "AGA", "AGG"],  # Arginina
            "gly": ["GGU", "GGC", "GGA", "GGG"],           # Glicina

            # Codones de parada (stop codons)
            "stop": ["UAA", "UAG", "UGA"]
        }

            
        for aa in codigo_gen: 
            if codon in codigo_gen[aa]: 
                self.aminoacido=aa 
                return aa
    
    def longitud(self):
        return super().longitud() 
    
#funcion para crear genes aleatorios 
def crear_gen(tam):
    bases=list("AGCT") 
    i=0
    gen="".join([random.choice(bases)for i in range(i,tam)])
    return gen
    
#Creamos un tRNA aleatorio 
tRNA_val=tRNA(crear_gen(70),"foward",0,70,"GUC") 
#utilizamos los metodos de la clase 
print(f"El gen del tRNA transcrito luce:{tRNA_val.transcribir()}, su partes lucen: {tRNA_val.estructura()}, el aminoacido cargado es: {tRNA_val.detectar_aa(tRNA_val.anticodon)}\n")
    
    
class ncRNA(Gen): 
    
    def __init__(self, Secuencia, cadena, inicio, fin, codificante):
        super().__init__( Secuencia, cadena, inicio, fin, codificante)
        self.codificante=False
        
    def transcribir(self):
        return super().transcribir() 
    
    def tipo(self): 
        tam=super().longitud()
        clasificacion_len={ 
            "miRNA":[70,100], 
            "piRNA":[0,25],
            "siRNA":[26,69],
            "lncRNA":[200,100000]  
            } 
        for rna in clasificacion_len: 
            if tam>=clasificacion_len[rna][0] and tam<=clasificacion_len[rna][1]:
                return rna 
            
#creamos un ncRNA aleatorio 
miRNA=ncRNA(crear_gen(26),"foward",50,76,False)
#utilizamos sus metodos 
print(f"El transcrito del gen luce: {miRNA.transcribir()}, por su tamaño se trata de un {miRNA.tipo()}\n")
    
    
class proteina(tRNA): 
    
    def __init__(self, Secuencia, cadena, inicio, fin, anticodon):
        super().__init__(Secuencia, cadena, inicio, fin, anticodon)
         
    def transcribir(self, codon="none"):
        return super(tRNA,self).transcribir(codon)
    
    def traducir(self,marco=0):
        codones=super().marcos_lectura()
        sec_aa=[self.detectar_aa(codon) for codon in codones[marco]] 
        return sec_aa
    
    def detectar_orf(self): 
        marco=self.traducir()
        marco=list(marco)
        codon_inicio="met"
        if codon_inicio in marco: 
            Orf=marco[marco.index("met"):marco.index("stop"):]            
            return Orf 
        else: 
            return("Su proteina no cuenta con un Orf en ese marco de lectura")
    
        
    def longitud(self):
        return len(self.traducir())
    
    
#creamos el gen de una proteina aleatorio 
prot=proteina(crear_gen(150),"foward",0,150,"none") 
print(f"La longitud de la proteina es {prot.longitud()}, su peptido luce: {prot.traducir()} y cuenta con el siguiente Orf: {prot.detectar_orf()}\n")
    

