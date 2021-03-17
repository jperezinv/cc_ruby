require_relative 'Cache'
require_relative 'MData'


class Demo
    def self.correrCasos(cache, s)
        s.puts("Bienvenido a la DEMO del EMULADOR MEMCACHED.")
        s.puts("La misma ejecturá algunos casos de prueba para los comandos set, add, get, replace, y append, y mostrará los resultados.")
        sleep(10)
        s.puts("\u001B[2J") 
        
        casosPrueba = ["set llave1 0 15 80", "Esta es la llave 1 y se borarrá dentro 15 de segundos..", "add llave1 1 60 80", "Este add fallará, debido a que ya existe la llave1",
            "add llave2 3 0 150", "Este si.. agregará la llave2, ya que no existe, y no se borrará (exp time = 0) mientras esta DEMO siga corriendo.", "get llave2",
            "set llave3 2 0 100", "Soy la llave 3 y", "replace llave2 3 0 30", "Me reemplazaron el texto", "append llave3 2 0 50", " me appendiaron este texto al final.",
            "get llave3", "get llave1 llave2 llave3", "quit"]
       
        cont = 0
        salir = false
        
        while !salir

            Thread.new do
                while true do
                    cache.controlTiempo(cache.datos)
                    sleep 1 #se ejecutará todo el tiempo mientras dure el emulador memcached, el control de tiempo, para ir borrando las keys expiradas.
                end
            end
            
            s.puts("COMANDO INGRESADO: #{casosPrueba[cont]}")
            comandos = cache.stringToArray(casosPrueba[cont])
            cont += 1
            
            if(comandos[0] == "quit")
                salir = true
                next;
            end            
            
            case comandos[0]
                
                when "set"
                    s.print("CHUNK INGRESADO: #{casosPrueba[cont]}\n\n")
                    chunk = casosPrueba[cont]
                    cont += 1
                    auxInfo = cache.datosToArray(comandos, chunk)
                    if(auxInfo == nil)
                        s.puts "ERROR"
                        next
                    end
                    auxInfo.shift()
                    mData = MData.new(auxInfo) #creo instancia de objeto 'DataM'
                    ret = cache.comandoSet(auxInfo[0], mData)
                    s.puts(ret)
                    s.puts("\n\n")
                when "add"
                    s.print("CHUNK INGRESADO: #{casosPrueba[cont]}\n\n")
                    chunk = casosPrueba[cont]
                    cont += 1
                    auxInfo = cache.datosToArray(comandos, chunk)
                    if(auxInfo == nil)
                        s.puts "ERROR"
                        next
                    end
                    auxInfo.shift()
                    ret = cache.comandoAdd(auxInfo[0], auxInfo)
                    s.puts(ret) 
                    s.puts("\n\n")
                when "replace"
                    s.print("CHUNK INGRESADO: #{casosPrueba[cont]}\n\n")
                    chunk = casosPrueba[cont]
                    cont += 1
                    auxInfo = cache.datosToArray(comandos, chunk)
                    if(auxInfo == nil)
                        s.puts "ERROR"
                        next
                    end
                    auxInfo.shift()
                    ret = cache.comandoReplace(auxInfo[0], auxInfo)
                    s.puts(ret)
                    s.puts("\n\n")
                when "append"
                    s.print("CHUNK INGRESADO: #{casosPrueba[cont]}\n\n")
                    chunk = casosPrueba[cont]
                    cont += 1
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
                        s.puts("\n\n")
                    else
                        s.puts "NOT_STORED. La llave ingresada no existe"
                    end
                    
                when "get"
                    s.puts("\n\n")
                    comandos.shift()
                    ret = cache.comandoGet(comandos)
                    s.puts(ret)
                    s.puts("\n\n")
                else
                    s.puts("COMANDO INGRESADO NO EXISTENTE. INTENTE NUEVAMENTE.\n\n") 
                
            end 
            sleep(2)
        end 
        s.puts("La DEMO de MEMCACHED EMULATOR ha terminado. ingrese Enter para volver al menu principal.")
        s.gets.chomp
    end
end



