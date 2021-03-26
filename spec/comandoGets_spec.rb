require_relative '../lib/Cache.rb'
require_relative '../lib/MData.rb'



describe Cache do
    
    context "en comandoGets" do
        
        it "Key existente, devolverá un array conteniendo un string con
        los datos, precedido por 'VALUE' y finalizado en 'END'" do
            
            mem = Cache.new()
            auxArr = ["mykey","0","0","50","Hola, testeando."]
            data = MData.new(auxArr)
            mem.comandoSet(auxArr[0], data) #seteo key: mykey con 
                                            #valor: "Hola, testeando"
            llave = ["mykey"]
            retornara = ["VALUE mykey 0 50 1\r\n Hola, testeando."]
            ret = mem.comandoGets(llave)
            expect(ret).to eq retornara
        end

        it "Keys existentes, devolvera un array conteniendo strings
        con los datos, precedidos por 'VALUE' y finalizado en 'END'" do
            
            mem = Cache.new()
            auxArr1 = ["mykey1","0","0","50","Hola, testeando."]
            data1 = MData.new(auxArr1)
            mem.comandoSet(auxArr1[0], data1)
            
            auxArr2 = ["mykey2","0","0","50","Hola, testing."]
            data2 = MData.new(auxArr2)
            mem.comandoSet(auxArr2[0], data2)

            auxArr3 = ["mykey3","0","0","50","Hola, testeandou."]
            data3 = MData.new(auxArr3)
            mem.comandoSet(auxArr3[0], data3)

            llaves = ["mykey1", "mykey2", "mykey3"]
            retornara = ["VALUE mykey1 0 50 1\r\n Hola, testeando.", "VALUE mykey2 0 50 2\r\n Hola, testing.", "VALUE mykey3 0 50 3\r\n Hola, testeandou."]
            ret = mem.comandoGets(llaves)
            expect(ret).to eq retornara

        end

        it "Key no existente, devolvera array vacio finalizado en 'END'" do
            
            mem = Cache.new()
            auxArr1 = ["mykey1","0","0","50","Hola, testeando."]
            data1 = MData.new(auxArr1)
            mem.comandoSet(auxArr1[0], data1)

            llave = ["mykey"]
            retornara = "NOT_STORED"
            ret = mem.comandoGets(llave)
            expect(ret).to eq retornara

        end

        it "Si la memoria esta vacia, devolvera 'AUN NO HAY KEYS GUARDADAS EN MEMORIA.'" do
            
            mem = Cache.new()
            llaves = ["mykey1", "mykey2", "mykey3"]
            retornara = "AUN NO HAY KEYS GUARDADAS EN MEMORIA."
            ret = mem.comandoGets(llaves)
            expect(ret).to eq retornara

        end

        it "Si ingreso key/s existente/s, y alguna de ellas no existe, simplemente retornara
        los valores de las que si existan en un array finalizado en 'END'" do
            
            mem = Cache.new()
            auxArr1 = ["mykey1","0","0","50","Hola, testeando."]
            data1 = MData.new(auxArr1)
            mem.comandoSet(auxArr1[0], data1)
            
            auxArr2 = ["mykey2","0","0","50","Hola, testing."]
            data2 = MData.new(auxArr2)
            mem.comandoSet(auxArr2[0], data2)

            llaves = ["mykey1", "mykey2", "mykey3"]
            retornara = ["VALUE mykey1 0 50 1\r\n Hola, testeando.", "VALUE mykey2 0 50 2\r\n Hola, testing."]
            ret = mem.comandoGets(llaves)
            expect(ret).to eq retornara

        end



    end



end