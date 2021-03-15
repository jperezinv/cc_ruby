require_relative = 'Cache'
require_relative = 'MData'


class MenuCache
        
    def self.menu(cache, s) #recibe cache y socket cliente
        
        salir = false

        while !salir

            Thread.new do
                while true do
                    cache.controlTiempo(cache.datos)
                    sleep 1   #se ejecutará todo el tiempo mientras dure el emulador memcached, el control de tiempo, para ir borrando las keys expiradas.
                end
            end
            
            s.puts("ingrese comando: ")
            comandos = cache.stringToArray(s.gets.chomp())
            
            if(comandos[0] == "quit")
                salir = true
                next;
            end            
            
            case comandos[0]
                
                when "set"
                    s.print("=>")
                    chunk = s.gets.chomp()
                    auxInfo = cache.datosToArray(comandos, chunk)
                    if(auxInfo == nil)
                        s.puts "ERROR"
                        next
                    end
                    auxInfo.shift()
                    mData = MData.new(auxInfo) #creo instancia de objeto 'DataM'
                    ret = cache.comandoSet(auxInfo[0], mData)
                    s.puts(ret)
                    s.puts ("#{cache.getHash}")
                when "add"
                    s.print("=>")
                    chunk = s.gets.chomp()
                    auxInfo = cache.datosToArray(comandos, chunk)
                    if(auxInfo == nil)
                        s.puts "ERROR"
                        next
                    end
                    auxInfo.shift()
                    ret = cache.comandoAdd(auxInfo[0], auxInfo)
                    s.puts(ret) 
                    s.puts ("#{cache.getHash}")
                when "replace"
                    s.print("=>")
                    chunk = s.gets.chomp()
                    auxInfo = cache.datosToArray(comandos, chunk)
                    if(auxInfo == nil)
                        s.puts "ERROR"
                        next
                    end
                    auxInfo.shift()
                    ret = cache.comandoReplace(auxInfo[0], auxInfo)
                    s.puts(ret)
                    s.puts ("#{cache.getHash}")
                when "append"
                    s.print("=>")
                    chunk = s.gets.chomp()
                    auxInfo = cache.datosToArray(comandos, chunk)
                    if(auxInfo == nil)
                        s.puts "ERROR"
                        next
                    end
                    auxInfo.shift()
                    if cache.datos.key?(auxInfo[0]) 
                        aux = cache.bytesCheck(auxInfo[0], auxInfo[4])
                        if (aux == nil)
                            s.puts "ERROR"
                            next
                        end    
                        ret = cache.comandoAppend(auxInfo[0], auxInfo)
                        s.puts(ret)
                        puts ("#{cache.getHash}")
                    else
                        s.puts "NOT_STORED. La llave ingresada no existe"
                    end
                    
                when "prepend"
                    s.print("=>")
                    chunk = s.gets.chomp()
                    auxInfo = cache.datosToArray(comandos, chunk)
                    if(auxInfo == nil)
                        s.puts "ERROR"
                        next
                    end
                    auxInfo.shift()
                    if cache.datos.key?(auxInfo[0]) 
                        aux = cache.bytesCheck(auxInfo[0], auxInfo[4])
                        if (aux == nil)
                            s.puts "ERROR"
                            next
                        end    
                        ret = cache.comandoPrepend(auxInfo[0], auxInfo)
                        s.puts(ret)
                        s.puts ("#{cache.getHash}")
                    else
                        s.puts "NOT_STORED. La llave ingresada no existe"
                    end                 
                    
                when "get"
                    comandos.shift()
                    ret = cache.comandoGet(comandos)
                    s.puts(ret)
                when "gets"
                    comandos.shift()
                    ret = cache.comandoGets(comandos)
                    s.puts(ret)
                when "cas"
                    s.print("=>")
                    chunk = s.gets.chomp()
                    auxInfo = cache.datosToArray(comandos, chunk)
                    if(auxInfo == nil)
                        s.puts "ERROR"
                        next
                    elsif (auxInfo.length != 7)
                        s.puts "ERROR"
                        next
                    end
                    auxInfo.shift()
                    if(cache.datos.key?(auxInfo[0]))
                        ret = cache.comandoCas(auxInfo[0], auxInfo)
                        s.puts(ret)
                        s.puts ("#{cache.getHash}")
                    else
                        s.puts "NOT_FOUND. La llave ingresada no existe.\n"
                    end
                else
                    s.puts("COMANDO INGRESADO NO EXISTENTE. INTENTE NUEVAMENTE.\n\n") 
                
            end 
        end 
    end
end