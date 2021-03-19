require_relative 'Cache'
require_relative 'MData'


class MenuCache
        
    def self.menu(cache, s) #recibe cache y socket cliente
        s.puts("Bievenido al MEMCACHED EMULATOR. Ingrese una linea de comando para comenzar:")
        s.puts("(Ingrese 'quit' para volver al menú principal)\n\n")
        salir = false
        while !salir

            Thread.new do
                while true do
                    cache.controlTiempo(cache.datos)
                    sleep 1 #se ejecutará todo el tiempo mientras dure el emulador memcached, el control de tiempo, para ir borrando las keys expiradas.
                end
            end
            
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
                when "append"
                    s.print("=>")
                    chunk = s.gets.chomp()
                    auxInfo = cache.datosToArray(comandos, chunk)
                    if(auxInfo == nil)
                        s.puts "ERROR"
                        next
                    end
                    auxInfo.shift()
                    ret = cache.comandoAppend(auxInfo[0], auxInfo)
                    s.puts(ret) 
                when "prepend"
                    s.print("=>")
                    chunk = s.gets.chomp()
                    auxInfo = cache.datosToArray(comandos, chunk)
                    if(auxInfo == nil)
                        s.puts "ERROR"
                        next
                    end
                    auxInfo.shift()
                    ret = cache.comandoPrepend(auxInfo[0], auxInfo)
                    s.puts(ret)                
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
                    ret = cache.comandoCas(auxInfo[0], auxInfo)
                    s.puts(ret)
                else
                    s.puts("COMANDO INGRESADO NO EXISTENTE. INTENTE NUEVAMENTE.\n\n") 
                
            end 
        end 
    end
end