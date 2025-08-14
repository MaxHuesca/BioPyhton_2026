# Creacion de la clase gen con 3 atributos y 3 metodos 

class Gen(): 
    #atributos del gen 
    longitud=0 
    Secuencia=[""]
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
        return [secuencia.replace("T", "U").strip() for secuencia in self.Secuencia]
    
    def marcos_lectura(self, marco):
        marco -=1
        codones= self.Secuencia[marco:] 
        return [self.Secuencia[pos:pos+3] for pos in len(codones)/3] 
    
    def GC(self):
        return self.Secuencia.count("G")+self.Secuencia.count("C")/len(self.Secuencia)
    

                


    