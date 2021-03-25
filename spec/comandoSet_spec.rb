require_relative '../lib/Cache.rb'
require_relative '../lib/MData.rb'



describe Cache do
    context "en comandoSet" do #si la key existe, sobreescribe. si no existe, simplemente la agrega a la memoria.
        
        it "Key no existente, devolverá 'STORED' cuando llamo al metodo comandoSet" do 
            
            mem = Cache.new()
            auxArr = ["mykey","0","0","50","Hola, testeando."]
            data = MData.new(auxArr)
            ret = mem.comandoSet(auxArr[0], data)
            expect(ret).to eq "STORED"
        end

        it "Key ya existente, sobreescribira y devolvera 'STORED'" do
            
            mem = Cache.new()
            auxArr = ["mykey","0","0","50","Hola, testeando."]
            data = MData.new(auxArr)
            mem.comandoSet(auxArr[0], data)

            auxArr2 = ["mykey","0","60","70","Hola, sobreescribí testeando."]
            data2 = MData.new(auxArr2)
            retornara = "STORED"
            ret = mem.comandoSet(auxArr2[0], data2)
            expect(ret).to eq retornara

        end

        it "Cuando el cache llegue a su tope (3) y quiera setear un nuevo valor, eliminará el valor
         de menos relevancia para hacer lugar (mykey1). Devolvera 'STORED'" do

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

            auxArr4 = ["mykey4", "0", "0", "50", "Se agregara y se eliminara la key1"]
            data4 = MData.new(auxArr4)
            ret = mem.comandoSet(auxArr4[0], data4)
            retornara = 'STORED'
            expect(ret).to eq retornara

        end

    end
end