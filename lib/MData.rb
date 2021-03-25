class MData
    attr_accessor :key, :flag, :exp_time, :bytes, :chunk, :valorCas

    def initialize(comandos)
        @key = comandos[0]
        @flag = comandos[1]
        if(comandos[2] == '0')
            @exp_time = 0
        else
            @exp_time = Time.now + comandos[2].to_i
        end
        @bytes = comandos[3]
        @chunk = comandos[4]
        @valorCas = 1
    end

end
