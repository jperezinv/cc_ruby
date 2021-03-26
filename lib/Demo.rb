require_relative 'Cache'
require_relative 'MData'

class Demo
    


    def self.correrCasos(cache, s)
        
        s.puts("Bienvenido a la DEMO del EMULADOR MEMCACHED.")
        s.puts("La misma ejecturá algunos casos de prueba para TODOS los comandos del MEMCACHED EMULATOR (set, add, get, gets, replace, append, prepend y cas) y mostrará los resultados.")
        sleep(10)
        s.puts("\u001B[2J") 
        
        casosPrueba = ["set llave1 0 15 80", "Esta es la llave 1 y se borarrá dentro 15 de segundos..", "add llave1 1 60 80", "Este add fallará, debido a que ya existe la llave1",
            "add llave2 3 0 150", "Este si.. agregará la llave2, ya que no existe, y no se borrará (exp time = 0) mientras esta DEMO siga corriendo.", "get llave2",
            "set llave3 2 0 100", "Soy la llave 3 y", "replace llave2 3 0 30", "Me reemplazaron el texto", "append llave3 2 0 50", " me appendiaron este texto al final.",
            "prepend llave3 2 0 28", "(y este texto adelante) ","get llave3", "get llave1 llave2 llave3", "gets llave2", "cas llave2 3 0 40 2", "Ahora me reemplazaron con CAS", "get llave2", "quit"]
       
        cont = 0
        salir = false
        
        while !salir

            Thread.new do
                while true do
                    cache.controlTiempo()
                    sleep 1 #se ejecutará todo el tiempo mientras dure el emulador memcached, el control de tiempo, para ir borrando las keys expiradas.
                end
            end
            
            s.puts("COMANDO INGRESADO: #{casosPrueba[cont]}") #mostrara el comando ingresado al usuario.
            comandos = cache.stringToArray(casosPrueba[cont])
            cont += 1 #contador que va avanzando por el array con todos los casos de prueba.
            
            if(comandos[0] == "quit")
                salir = true
                next;
            end      
            
            case comandos[0]
                
                when "set"
                    auxInfo = bloqueCheck(s, casosPrueba, comandos, cache, cont)
                    cont += 1
                    if (auxInfo == 'ERROR')
                        s.puts "ERROR"
                        next
                    else
                        mData = MData.new(auxInfo) #creo instancia de objeto 'DataM'
                        ret = cache.comandoSet(auxInfo[0], mData)
                        s.puts(ret)
                        s.puts("\n\n")
                    end
                when "add"
                    auxInfo = bloqueCheck(s, casosPrueba, comandos, cache, cont)
                    cont += 1
                    if (auxInfo == 'ERROR')
                        s.puts "ERROR"
                        next
                    else
                        ret = cache.comandoAdd(auxInfo[0], auxInfo)
                        s.puts(ret)
                        s.puts("\n\n") 
                    end
                when "replace"
                    auxInfo = bloqueCheck(s, casosPrueba, comandos, cache, cont)
                    cont += 1
                    if (auxInfo == 'ERROR')
                        s.puts "ERROR"
                        next
                    else
                        ret = cache.comandoReplace(auxInfo[0], auxInfo)
                        s.puts(ret)
                        s.puts("\n\n") 
                    end
                when "append"
                    auxInfo = bloqueCheck(s, casosPrueba, comandos, cache, cont)
                    cont += 1
                    if (auxInfo == 'ERROR')
                        s.puts "ERROR"
                        next
                    else
                        ret = cache.comandoAppend(auxInfo[0], auxInfo)
                        s.puts(ret)
                        s.puts("\n\n") 
                    end
                when "prepend"
                    auxInfo = bloqueCheck(s, casosPrueba, comandos, cache, cont)
                    cont += 1
                    if (auxInfo == 'ERROR')
                        s.puts "ERROR"
                        next
                    else
                        ret = cache.comandoPrepend(auxInfo[0], auxInfo)
                        s.puts(ret)
                        s.puts("\n\n") 
                    end          
                when "get"
                    comandos.shift()
                    ret = cache.comandoGet(comandos)
                    s.puts(ret)
                    s.puts("\n\n")
                when "gets"
                    comandos.shift()
                    ret = cache.comandoGets(comandos)
                    s.puts(ret)
                    s.puts("\n\n")
                when "cas"
                    s.print("CHUNK INGRESADO: #{casosPrueba[cont]}\n\n")
                    chunk = casosPrueba[cont]
                    cont += 1
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
                    s.puts("\n\n")
                
                end 
                sleep(2)
        end 
        s.puts("La DEMO de MEMCACHED EMULATOR ha terminado. ingrese Enter para volver al menu principal.")
        s.gets.chomp
    end

    def self.bloqueCheck(s, casosPrueba, comandos, cache, cont)
        s.print("CHUNK INGRESADO: #{casosPrueba[cont]}\n\n")
        chunk = casosPrueba[cont]
        if(comandos.length != 5)
            return "ERROR"
        end
        auxInfo = cache.datosToArray(comandos, chunk)
        if(auxInfo == nil)
            return "ERROR"
        end
        auxInfo.shift()
        return auxInfo
    end
end



