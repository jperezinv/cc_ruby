require_relative 'Cache'
require_relative 'MData'


class MenuCache
        
    def self.menu(cache, s) #recibe cache y cliente.
        s.puts("Bievenido al MEMCACHED EMULATOR. Ingrese una linea de comando para comenzar:")
        s.puts("(Ingrese 'quit' para volver al menú principal)\n\n")
        salir = false
        while !salir

            Thread.new do #se ejecutará todo el tiempo mientras dure el emulador memcached, el control de tiempo, para ir borrando las keys expiradas.
                while true do
                    cache.controlTiempo(cache.datos)
                    sleep 1 
                end
            end
            
            #consume la linea de comando ingresada, terminada por caracter enter, 
            #y devuelve un arreglo con el string separado por espacios.
            comandos = cache.stringToArray(s.gets.chomp()) 
            
            if(comandos[0] == "quit") #si el usuario ingreso 'quit', regresará al menu principal
                salir = true
                next;
            end            
            
            case comandos[0] #en la posicion 0 del arreglo se encuentra el comando a ejecutar (set, add, get, etc..)
                
                when "set"
                    s.print("=>")
                    chunk = s.gets.chomp() #consume el chunk terminado en enter.
                    if(comandos.length != 5) #si el largo del array comandos es mayor a 5, es que el usuario ingreso algo de mas. en este caso sale con mensaje de ERROR.
                        s.puts "ERROR"
                        next
                    end
                    auxInfo = cache.datosToArray(comandos, chunk) #funcion aux de checkeo de comandos.
                    if(auxInfo == nil)
                        s.puts "ERROR"
                        next
                    end
                    auxInfo.shift() #quito del frente del arreglo el nombre del comando, que ya no será necesario.
                    mData = MData.new(auxInfo) #creo instancia de objeto 'DataM' para setearlo
                    ret = cache.comandoSet(auxInfo[0], mData)
                    s.puts(ret)
                when "add"
                    s.print("=>")
                    chunk = s.gets.chomp()
                    if(comandos.length != 5)
                        s.puts "ERROR"
                        next
                    end
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
                    if(comandos.length != 5)
                        s.puts "ERROR"
                        next
                    end
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
                    if(comandos.length != 5)
                        s.puts "ERROR"
                        next
                    end
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
                    if(comandos.length != 5)
                        s.puts "ERROR"
                        next
                    end
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
                    elsif (auxInfo.length != 7) #checkeo auxiliar. si el largo del array que contiene la linea de comando es distinto de 7
                                                #entonces el usuario ingreso algo de mas. devuelve ERROR y sigue.
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