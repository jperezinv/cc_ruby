require_relative 'Cache'
require_relative 'MData'

describe Cache do
    
    context "en comandoReplace" do
        
        it "Key existente, reemplazara los bytes y el chunk ingresados
        y devolvera 'STORED'" do
            
        mem = Cache.new()
        auxArr = ["mykey","0","0","50","Hola, testeando."]
        data = MData.new(auxArr)
        mem.comandoSet(auxArr[0], data)

        auxArr2 = ["mykey", "0", "0", "20", "Cambie el texto"]
        ret = mem.comandoReplace(auxArr2[0],auxArr2)
        retornara = "STORED"
        expect(ret).to eq retornara

        end
        
        it "Key no existente, no reemplazara nada y devolvera 'NOT STORED'" do

            mem = Cache.new()
            auxArr = ["mykey","0","0","50","Hola, testeando."]
            data = MData.new(auxArr)
            mem.comandoSet(auxArr[0], data)

            auxArr2 = ["mykey3", "2", "190", "25", "No existe la llave"]
            ret = mem.comandoReplace(auxArr2[0], auxArr2)
            retornara = "NOT_STORED"
            expect(ret).to eq retornara

        end
    
    
    end
end