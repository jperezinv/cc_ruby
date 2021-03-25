require_relative '../lib/Cache.rb'
require_relative '../lib/MData.rb'

describe Cache do
    context "en comandoAdd" do
        it "Key no existente, la agregara y devolvera 'STORED'" do
            
            mem = Cache.new()
            auxArr = ["mykey","0","0","50","Hola, testeando."]
            ret = mem.comandoAdd(auxArr[0], auxArr)
            retornara = "STORED"
            expect(ret).to eq retornara
        
        end

        it "Key ya existente, no agregara y devolvera mismo protocolo de comando get (VALUE y valores)" do
            
            mem = Cache.new()
            auxArr = ["mykey","0","0","50","Hola, testeando."]
            data = MData.new(auxArr)
            mem.comandoSet(auxArr[0], data) #seteo la key mykey

            auxArr = ["mykey","3","180","70","Intentando agregar una key ya existente."]
            ret = mem.comandoAdd(auxArr[0], auxArr)
            retornara = ["VALUE mykey 0 50\r\n Hola, testeando."]
            expect(ret).to eq retornara

        end
    end
end