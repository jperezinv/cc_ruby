class LRUCache
  attr_accessor :maxTamanio, :datos 

  def initialize(maxTamanio = 3)
    @datos = {"a"=>"1", "b"=>"2", "c"=>"3"} #el ultimo sera el primero en el LRU
    @maxTamanio = maxTamanio
  end

  def getHash
    return @datos.to_a.reverse
  end

  
  def comandoGet(llaves) #recibe una/s key/s y devuelve el/los valor/valores
  
    if @datos.empty?
      return puts "el hash esta vacio"
    end
    
    data = []
    cont = 0
    
    if llaves.length > 0
      llaves.each do |llave|
        for k in @datos.keys
          if k == llave
            borrado = @datos.delete(k) #borro y obtengo el valor borrado
            @datos[k] = borrado #lo vuelvo a insertar con esa misma llave, ya que se accedió recientemente.
            data[cont] = "VALUE {#{k} => #{@datos[k]}}" #despues guardo el par key-valor en el array que retornaré al final 
            cont += 1
          end    
        end
      end
    end
  
    if !data.empty? #si no esta vacio, devuelvo el array con los valores que tenga
      return data #el output sera VALUE seguido de la KEY y el VALOR
    else
      return nil #si esta vacio entonces devuelvo nil
    end
  
  end

  def comandoSet(llave, valor) #recibe una key y un valor y los setea. si ya existe la key, sobreescribirá
    
    @datos.delete(llave) #borro lo que este con esa llave
    @datos[llave] = valor #e inserto al final

    if @datos.length > maxTamanio
      @datos.delete(@datos.keys[0]) #si el tamaño es mayor al maxTamanio, borro el primer elemento del hash (el de menos relevancia)
    end
    
    return puts("se ha seteado el valor #{valor} a la key #{llave}") #output será STORED
  
  end

  def comandoAdd (llave, valor)
    if @datos.key?(llave)
      auxArr = [llave]
      return comandoGet(auxArr) #output será NOT_STORED
    end
    comandoSet(llave,valor)
  end

  def comandoReplace(llave,valor)
    if @datos.key?(llave)
      comandoSet(llave, valor)
    else 
      return puts "la llave ingresada no existe"
    end
  end

  def comandoAppend(llave, valor)
    if @datos.key?(llave)
      return @datos[llave] = @datos[llave]+valor
    else
      return puts "la llave ingresada no existe"
    end
  end

  def comandoPrepend(llave, valor)
    if @datos.key?(llave)
      return @datos[llave] = valor+@datos[llave]
    else
      return puts "la llave ingresada no existe"
    end
  end

  def comandoGets()

  
  
end



cache = LRUCache.new()
puts ("\n")
puts("#{cache.getHash}\n")

arr = ["c"]
puts ("Prueba comando GET: para c el valor es #{cache.comandoGet(arr)}\n\n")
puts("#{cache.getHash}\n")


puts("#{cache.comandoSet("b", "22")}\n")
puts("#{cache.comandoSet("a","11")}")
puts("#{cache.getHash}\n")

puts("Prueba para comando ADD: agrega una key ya existente (c). Fallará pero igual movera a c al comienzo del LRU #{cache.comandoAdd("c",5)}")
puts("#{cache.getHash}\n")

puts("Ahora agregaré una llave nueva. #{cache.comandoAdd("d","6")}")
puts("#{cache.getHash}\n")

puts("Prueba para comando REPLACE: intento con una key que no existe (f) y despues con una que si (d)\n\n")
puts("#{cache.comandoReplace("f","50")}")
puts("#{cache.comandoReplace("d","10")}")
puts("#{cache.getHash}\n")


puts("Prueba para comando APPEND: modificare el valor de d 1020. #{cache.comandoAppend("d","20")}")
puts("#{cache.getHash}\n")

puts("Prueba para comando PREPEND: modificare el valor de c a albercaaaa3. #{cache.comandoPrepend("c","albercaaaa")}")
puts("#{cache.getHash}\n")


#prueba de commit




