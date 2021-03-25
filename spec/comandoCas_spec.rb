require_relative '../lib/Cache.rb'
require_relative '../lib/MData.rb'



describe Cache do
    
    context "comando Cas" do
        
        it "Key ingresada existe y el valor cas SI coincide, entonces se setearan los valores y retornara 'STORED'" do
            
            mem = Cache.new()
            auxArr = ["mykey","0","0","50","Hola, testeando."]
            data = MData.new(auxArr)
            mem.comandoSet(auxArr[0], data)
            llave = ["mykey"]
            mem.comandoGets(llave)

            auxArr2 = ["mykey", "20", "0", "50", "1", "Cambie con CAS" ]
            ret = mem.comandoCas(auxArr2[0], auxArr2)
            retornara = "STORED"
            expect(ret).to eq retornara

        end

        it "Key ingresada existe y el valor cas NO coincide, entonces no se setearan los valores y retornara 'EXISTS'" do
            
            mem = Cache.new()
            auxArr = ["mykey","0","0","50","Hola, testeando."]
            data = MData.new(auxArr)
            mem.comandoSet(auxArr[0], data)
            llave = ["mykey"]
            mem.comandoGets(llave)

            auxArr2 = ["mykey", "20", "0", "50", "5", "Cambie con CAS" ]
            ret = mem.comandoCas(auxArr2[0], auxArr2)
            retornara = "EXISTS"
            expect(ret).to eq retornara

        end

        it "Key ingresada no existe, no se setearan los valores y retornara 'NOT_FOUND'" do
            
            mem = Cache.new()
            auxArr = ["mykey","0","0","50","Hola, testeando."]
            data = MData.new(auxArr)
            mem.comandoSet(auxArr[0], data)
            llave = ["mykey"]
            mem.comandoGets(llave)

            auxArr2 = ["mykyky", "20", "0", "50", "7", "Cambie con CAS" ]
            ret = mem.comandoCas(auxArr2[0], auxArr2)
            retornara = "NOT_FOUND"
            expect(ret).to eq retornara

        end



    end



end