require_relative '../lib/MenuCache'
require_relative '../lib/MData'

describe Cache do
    
    context "Funciones Auxiliares" do
        
        it "soloNum con datos validos: recibira un string de solo digitos y retornara true." do
            
            mem = Cache.new()
            auxString = "0123"
            ret = mem.soloNum(auxString)
            retornara = true
            expect(ret).to eq retornara
        end

        it "soloNum con datos no validos: recibra un string con algun caracter que no sea digito y retornara false." do
            
            mem = Cache.new()
            auxString = "01A3"
            ret = mem.soloNum(auxString)
            retornara = false
            expect(ret).to eq retornara
        
        end

        it "datosToArray con datos validos: recibe la linea de comando y el chunk en arrays separados por espacios, 
        y si pasa los controles, unirá estos dos en un mismo arreglo y los retornará" do

            mem = Cache.new()
            comandos = "set mykey 0 0 50"
            chunk = "Testeando funciones aux"
            auxArr1 = mem.stringToArray(comandos)
            ret = mem.datosToArray(auxArr1,chunk)
            retornara = ["set", "mykey", "0", "0", "50", "Testeando funciones aux"]
            expect(ret).to eq retornara    
        
        end

        it "datosToArray con datos no validos: si <flag>, <exp time> o <bytes> no son DIGITOS, entonces retornara NIL." do
            
            mem = Cache.new()
            comandos = "set mykey 0 A 50"
            chunk = "Testeando funciones aux"
            auxArr1 = mem.stringToArray(comandos)
            ret = mem.datosToArray(auxArr1,chunk)
            retornara = nil
            expect(ret).to eq retornara 

        end
        
        it "datosToArray con datos no validos: si bytes es menor al largo del chunk ingresado, retornara NIL" do

            mem = Cache.new()
            comandos = "set mykey 0 0 10"
            chunk = "Testeando funciones aux"
            auxArr1 = mem.stringToArray(comandos)
            ret = mem.datosToArray(auxArr1,chunk)
            retornara = nil
            expect(ret).to eq retornara 
        
        end

        it "bytesCheck con datos no validos: recibe una llave y el texto, si el largo del texto a appendiar/preprendiar + el valor 
        de la llave es mayor a los bytes de la llave, entonces retornara NIL" do
                
            mem = Cache.new()
            auxArr = ["mykey","0","0","20","Hola, testeando."]
            data = MData.new(auxArr)
            mem.comandoSet(auxArr[0], data)

            texto = "Este texto es muy largo para la key"
            llave = "mykey"
            ret = mem.bytesCheck(llave, texto)
            retornara = nil
            expect(ret).to eq retornara

        end

        it "bytesCheck con datos validos: si el largo del texto a appendiar/prependiar + el valor 
        de la llaves menor a los bytes de la llave, entonces retornara el texto" do
            
            mem = Cache.new()
            auxArr = ["mykey","0","0","50","Hola, testeando."]
            data = MData.new(auxArr)
            ret = mem.comandoSet(auxArr[0], data)

            texto = "Este texto esta bien"
            llave = "mykey"
            ret = mem.bytesCheck(llave,texto)
            retornara = texto
            expect(ret).to eq retornara

        end

    end

end