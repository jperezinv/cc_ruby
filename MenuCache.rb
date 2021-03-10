require_relative = 'Cache'


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
            
            chunk = gets.chomp()
            
            case comandos[0]
                
                when "set"
                    auxInfo = cache.datosToArray(comandos, chunk)
                    if(auxInfo == nil)
                        puts("CLIENT_ERROR bad data chunk")
                        next
                    end
                    comando = auxInfo.shift()
                    llave = auxInfo.shift()
                    valor = auxInfo
                    puts("#{comando}")
                    puts("#{llave}")
                    puts("#{valor}")
                    cache.comandoSet(llave, valor)
                    puts ("#{cache.getHash}")
                when "add"
                    auxInfo = cache.datosToArray(comandos, chunk)
                    if(auxInfo == nil)
                        puts("CLIENT_ERROR bad data chunk")
                        next
                    end
                    comando = auxInfo.shift()
                    llave = auxInfo.shift()
                    valor = auxInfo
                    puts("#{comando}")
                    puts("#{llave}")
                    puts("#{valor}")
                    cache.comandoAdd(llave, valor)
                    puts ("#{cache.getHash}")
                when "replace"
                    auxInfo = cache.datosToArray(comandos, chunk)
                    if(auxInfo == nil)
                        puts("CLIENT_ERROR bad data chunk")
                        next
                    end
                    comando = auxInfo.shift()
                    llave = auxInfo.shift()
                    valor = auxInfo
                    puts("#{comando}")
                    puts("#{llave}")
                    puts("#{valor}")
                    cache.comandoReplace(llave, valor)
                    puts ("#{cache.getHash}")
                when "append"
                    auxInfo = cache.datosToArray(comandos, chunk)
                    if(auxInfo == nil)
                        puts("CLIENT_ERROR bad data chunk")
                        next
                    end
                    comando = auxInfo.shift()
                    llave = auxInfo.shift()
                    valor = auxInfo
                    puts("#{comando}")
                    puts("#{llave}")
                    puts("#{valor}")
                    cache.comandoAppend(llave, valor)
                    puts ("#{cache.getHash}")
                when "prepend"
                    auxInfo = cache.datosToArray(comandos, chunk)
                    if(auxInfo == nil)
                        puts("CLIENT_ERROR bad data chunk")
                        next
                    end
                    comando = auxInfo.shift()
                    llave = auxInfo.shift()
                    valor = auxInfo
                    puts("#{comando}")
                    puts("#{llave}")
                    puts("#{valor}")
                    cache.comandoPrepend(llave, valor)
                    puts ("#{cache.getHash}")
                when "get"#
                when "gets"# FALTA IMPLEMENTAR GETS Y CAS. PARA ESTOS 3 COMANDOS TAMBIEN IMPLEMENTARE UNA FORMA DISTINTA DE AGARRAR LA INFO..
                when "cas"#
                else
                    puts("ERROR: COMANDO NO EXISTENTE. INTENTE NUEVAMENTE.\n\n") 
                
            end 
        end 
    end
end