require_relative 'Cache'
require_relative 'MData'


describe Cache do
    context "en comandoSet" do
        it "Datos correctos, devolverá 'STORED' cuando llamo al metodo comandoSet" do
            mem = Cache.new()
            auxArr = ["mykey","0","0","50","Hola, testeando."]
            data = MData.new(auxArr)
            ret = mem.comandoSet(auxArr[0], data)
            expect(ret).to eq "STORED"
        end
    end
end