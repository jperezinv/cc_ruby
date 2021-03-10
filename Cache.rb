require_relative = 'MenuCache'

class Cache
  attr_accessor :maxTamanio, :datos 

  def initialize(maxTamanio = 3)
    @datos = {} #el ultimo sera el primero en el LRU
    @maxTamanio = maxTamanio
  end

  #FUNCIONES AUXILIARES

  def getHash
    return @datos.to_a.reverse
  end

  #para comandos set, add, replace, append y preppend
  def datosToArray(comandos, chunk) #recibe comandos (comando, key, flag, exptime, bytes) y data chunk, separa los comandos por espacios y genera un array.
    
    if (comandos[4].to_i < chunk.length) #auxArr[4] representa los bytes del chunk.
      return nil
    else
      comandos.push(chunk)
      return comandos #retorno un array con TODA la informacion (comando, key, flag, exptime, bytes y chunk)
    end
  end

  def stringToArray(string) #para comando get y gets
    return string.split(" ")
  end
  

  #COMANDOS

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
            data[cont] = "VALUE #{k} => #{@datos[k][3]}" #despues guardo el par key-valor en el array que retornaré al final 
            cont += 1
          end    
        end
      end
    end
  
    if !data.empty? #si no esta vacio, devuelvo el array con los valores que tenga
      return puts data #el output sera VALUE seguido de la KEY y el VALOR
    else
      return puts ("esta vacio") #si esta vacio entonces devuelvo nil
    end
  
  end

  def comandoSet(llave, valor) #recibe una key y un valor y los setea. si ya existe la key, sobreescribirá
    
    @datos.delete(llave) #borro lo que este con esa llave
    @datos[llave] = valor #e inserto al final

    if @datos.length > maxTamanio
      @datos.delete(@datos.keys[0]) #si el tamaño es mayor al maxTamanio, borro el primer elemento del hash (el de menos relevancia)
    end
    
    return puts("se ha seteado el valor #{valor[3]} a la key #{llave}") #output será STORED
  
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
      bytes = valor[2].to_i + @datos[llave][2].to_i
      @datos[llave][2] = bytes.to_s
      return puts @datos[llave][3] = @datos[llave][3]+valor[3]
    else
      return puts "la llave ingresada no existe"
    end
  end

  def comandoPrepend(llave, valor)
    if @datos.key?(llave)
      bytes = valor[2].to_i + @datos[llave][2].to_i
      @datos[llave][2] = bytes.to_s
      return puts @datos[llave][3] = valor[3]+@datos[llave][3]
    else
      return puts "la llave ingresada no existe"
    end
  end

end
