# Creacion de la clase gen con 3 atributos y 3 metodos 

class Gen():  
    bases= {
        "A":"U", 
        "T":"A",
        "C":"G",
        "G":"C"
    }
    
    def __init__(self, tamaño, Secuencia, cadena, inicio, fin):
        self.longitud= tamaño
        self.Secuencia="".join(Secuencia)
        self.cadena= cadena 
        self.start= inicio
        self.stop= fin
        pass
    
    def transcirbir(self): 
        RNA=self.Secuencia
        if self.cadena=="foward": 
            RNA=RNA.replace("T","U")
            return RNA
        else: 
            for complemento in self.bases:
                RNA=RNA.replace(complemento, self.bases[complemento])      
            return RNA[::-1]
    
    def marcos_lectura(self):
        codones= [self.Secuencia[i:] for i in range(0,3)] 
        marcos=[[marco[pos:pos+3] for pos in range(0,round(len(marco)/3))] for marco in codones]
        
        return marcos 
                
    
    def GC(self):
        return self.Secuencia.count("G")+self.Secuencia.count("C")/len(self.Secuencia)
    

lacY=Gen(96,"ATCGTTTAAACGACTTTTACGGGGATTTACCCATTTTAGGCATTTTATCGATCGGGATCCACTGCATTACCCGCTACGCTTAGTCGATGCTGATCG", "reverse",20167,20263) 

lacY_RNA=lacY.transcirbir()               
codones=lacY.marcos_lectura()
lac_Y_GC=lacY.GC()

print(f"El transcrito de lacY es {lacY_RNA}, sus codones lucen: {codones} y su contenido de GC es de: {lac_Y_GC}")
