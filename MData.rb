class MData
    attr_accessor :key, :flag, :exp_time, :bytes, :chunk, :valorCas

    def initialize(comandos)
        @key = comandos[0]
        @flag = comandos[1]
        @exp_time = comandos[2]
        @bytes = comandos[3]
        @chunk = comandos[4]
        @valorCas = nil
    end

end
