require_relative 'Cache'
require_relative 'MData'

describe Cache do
    context "en comandoAppend" do
        
        it "Key existente y largo del texto a appendiar correcto, appendeara el texto y retornara 'STORED'" do
            
            mem = Cache.new()
            auxArr = ["mykey","0","0","50","Hola, testeando."]
            data = MData.new(auxArr)
            mem.comandoSet(auxArr[0], data)

            auxArr2 = ["mykey", "0", "0", "10", "Appendie"]
            ret = mem.comandoAppend(auxArr2[0], auxArr2)
            retornara = "STORED"
            expect(ret).to eq retornara
        
        end

        it "Key no existente, retornara 'NOT_STORED'" do
            
            mem = Cache.new()
            auxArr = ["mykey","0","0","50","Hola, testeando."]
            data = MData.new(auxArr)
            mem.comandoSet(auxArr[0], data)

            auxArr2 = ["mykey2", "2", "180", "50", "Texto no existente"]
            ret = mem.comandoAppend(auxArr2[0], auxArr2)
            retornara = "NOT_STORED"
            expect(ret).to eq retornara

        end

        it "el largo del texto a appendear excede, junto con el largo del chunk, al total de bytes de la key." do
            
            mem = Cache.new()
            auxArr = ["mykey","0","0","20","Hola, testeando."]
            data = MData.new(auxArr)
            mem.comandoSet(auxArr[0], data)

            auxArr2 = ["mykey", "0", "0", "10", "Excede"]
            ret = mem.comandoAppend(auxArr2[0], auxArr2)
            retornara = "ERROR"
            expect(ret).to eq retornara
            
        end

    end


end