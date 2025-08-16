# Creacion de la clase gen con 3 atributos y 3 metodos 

class Gen(): 
    #atributos del gen 
    longitud=0 
    Secuencia=""
    cadena=""
    start=0 
    stop=0 
    
    def __init__(self, tamaño, Secuencia, cadena, inicio, fin):
        self.longitud= tamaño
        self.Secuencia=Secuencia.upper
        self.cadena= cadena 
        self.start= inicio
        self.stop= fin
        pass
    
    def transcirbir(self): 
        if self.cadena=="foward": 
            return [secuencia.replace("T", "U").strip() for secuencia in self.Secuencia]
        else: 
            self.Secuencia.replace("A","G")
            self.Secuencia.replace("G","A")
            self.Secuencia.replace("T","A")
            self.Secuencia.replace("A","U")
            return self.Secuencia[-1::]
    
    def marcos_lectura(self, marco):
        marco -=1
        codones= self.Secuencia[marco:] 
        return [self.Secuencia[pos:pos+3] for pos in len(codones)/3] 
    
    def GC(self):
        return self.Secuencia.count("G")+self.Secuencia.count("C")/len(self.Secuencia)
    

lacY=Gen(96,"ATCGTTTAAACGACTTTTACGGGGATTTACCCATTTTAGGCATTTTATCGATCGGGATCCACTGCATTACCCGCTACGCTTAGTCGATGCTGATCG", "reverse",20167,20263) 

lacY_RNA=lacY.transcirbir                
codones=lacY.marcos_lectura
lac_Y_GC=lacY.GC

print(f"El transcrito de lacY es {lacY_RNA}, sus codones lucen: {codones} y su contenido de GC es de: {lac_Y_GC}")
