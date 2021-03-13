require_relative = 'Cache'
require_relative = 'MData'


class MenuCache
        
    def self.menu(cache)
        
        salir = false

        while !salir
            
            puts("ingrese comando: ")
            comandos = cache.stringToArray(gets.chomp())
            
            if(comandos[0] == "quit")
                salir = true
                next;
            end            
            
            case comandos[0]
                
                when "set"
                    chunk = gets.chomp()
                    auxInfo = cache.datosToArray(comandos, chunk)
                    if(auxInfo == nil)
                        puts("CLIENT_ERROR bad data chunk")
                        next
                    end
                    auxInfo.shift()
                    mData = MData.new(auxInfo) #creo instancia de objeto 'DataM'
                    cache.comandoSet(auxInfo[0], mData)
                    puts ("#{cache.getHash}")
                when "add"
                    chunk = gets.chomp()
                    auxInfo = cache.datosToArray(comandos, chunk)
                    if(auxInfo == nil)
                        puts("CLIENT_ERROR bad data chunk")
                        next
                    end
                    auxInfo.shift()
                    cache.comandoAdd(auxInfo[0], auxInfo)
                    puts ("#{cache.getHash}")
                when "replace"
                    chunk = gets.chomp()
                    auxInfo = cache.datosToArray(comandos, chunk)
                    if(auxInfo == nil)
                        puts("CLIENT_ERROR bad data chunk")
                        next
                    end
                    auxInfo.shift()
                    cache.comandoReplace(auxInfo[0], auxInfo)
                    puts ("#{cache.getHash}")
                when "append"
                    chunk = gets.chomp()
                    auxInfo = cache.datosToArray(comandos, chunk)
                    if(auxInfo == nil)
                        puts("CLIENT_ERROR bad data chunk")
                        next
                    end
                    auxInfo.shift()
                    if cache.datos.key?(auxInfo[0]) 
                        aux = cache.bytesCheck(auxInfo[0], auxInfo[4])
                        if (aux == nil)
                            puts("CLIENT_ERROR bad data chunk")
                            next
                        end    
                        cache.comandoAppend(auxInfo[0], auxInfo)
                        puts ("#{cache.getHash}")
                    else
                        puts("NOT_STORED. La llave ingresada no existe")
                    end
                    
                when "prepend"
                    chunk = gets.chomp()
                    auxInfo = cache.datosToArray(comandos, chunk)
                    if(auxInfo == nil)
                        puts("CLIENT_ERROR bad data chunk")
                        next
                    end
                    auxInfo.shift()
                    if cache.datos.key?(auxInfo[0]) 
                        aux = cache.bytesCheck(auxInfo[0], auxInfo[4])
                        if (aux == nil)
                            puts("CLIENT_ERROR bad data chunk")
                            next
                        end    
                        cache.comandoPrepend(auxInfo[0], auxInfo)
                        puts ("#{cache.getHash}")
                    else
                        puts("NOT_STORED. La llave ingresada no existe")
                    end                 
                    
                when "get"
                    comandos.shift()
                    cache.comandoGet(comandos)
                when "gets"# 
                    comandos.shift()
                    cache.comandoGets(comandos)
                when "cas"
                    chunk = gets.chomp()
                    auxInfo = cache.datosToArray(comandos, chunk)
                    if(auxInfo == nil)
                        puts("CLIENT_ERROR bad data chunk")
                        next
                    elsif (auxInfo.length != 7)
                        puts("ERROR")
                        next
                    end
                    auxInfo.shift()
                    if(cache.datos.key?(auxInfo[0]))
                        cache.comandoCas(auxInfo[0], auxInfo)
                        puts ("#{cache.getHash}")
                    else
                        puts("NOT_FOUND. La llave ingresada no existe.\n")
                    end
                else
                    puts("ERROR: COMANDO NO EXISTENTE. INTENTE NUEVAMENTE.\n\n") 
                
            end 
        end 
    end
end