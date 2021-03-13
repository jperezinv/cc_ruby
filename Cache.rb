require_relative = 'MenuCache'
require_relative = 'MData'

class Cache
  attr_accessor :maxTamanio, :datos, :tokenCas

  def initialize(maxTamanio = 3, tokenCas = 1)
    @datos = {} #el ultimo sera el primero en el LRU
    @maxTamanio = maxTamanio
    @tokenCas = tokenCas
  end

  #FUNCIONES AUXILIARES

  def getHash
    return @datos.to_a.reverse
  end

  def datosToArray(comandos, chunk) 
    
    if (comandos[4].to_i < chunk.length) #auxArr[4] representa los bytes del chunk.
      return nil
    else
      comandos.push(chunk)
      return comandos #retorno un array con TODA la informacion (comando, key, flag, exptime, bytes y chunk)
    end
  end

  def bytesCheck(llave, texto)
    bytes = @datos[llave].bytes
    value = @datos[llave].chunk
    if (bytes.to_i < texto.length + value.length)
      return nil
    else
      return texto
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
            data[cont] = "VALUE #{k} => #{@datos[k].chunk}" #despues guardo el par key-valor en el array que retornaré al final 
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

  def comandoSet(llave, data) #recibe una key y una instancia de 'MData', que guardara en el hash.
    @datos.delete(llave) #borro lo que este con esa llave
    @datos[llave] = data #e inserto al final

    if @datos.length > maxTamanio
      @datos.delete(@datos.keys[0]) #si el tamaño es mayor al maxTamanio, borro el primer elemento del hash (el de menos relevancia)
    end
    
    return puts("se ha seteado el valor #{data.chunk} a la key #{llave}") #output será STORED
  
  end

  def comandoAdd (llave, valores)
    if @datos.key?(llave)
      auxArr = [llave]
      return comandoGet(auxArr) #output será NOT_STORED
    end
    puts("La llave antes de crear instancia es: #{valores[0]}")
    mData = MData.new(valores)
    puts("La llave es #{mData.key}")
    comandoSet(llave,mData)
  end

  def comandoReplace(llave, valores)
    if @datos.key?(llave)
      @datos[llave].bytes = valores[3]
      @datos[llave].chunk = valores[4]
    else 
      return puts "la llave ingresada no existe"
    end
  end

  def comandoAppend(llave, valores)
    @datos[llave].chunk = @datos[llave].chunk+valores[4]
    return puts "STORED"
  end

  def comandoPrepend(llave, valores)
    @datos[llave].chunk = valores[4]+@datos[llave].chunk 
    return puts "STORED"
  end

  def comandoGets(llaves)
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
            borrado.valorCas = @tokenCas.to_s
            @datos[k] = borrado #lo vuelvo a insertar con esa misma llave, ya que se accedió recientemente.
            data[cont] = "VALUE #{k} #{@datos[k].flag} #{@datos[k].bytes} #{@datos[k].valorCas}\r\n #{@datos[k].chunk}" 
            cont += 1
            @tokenCas += 1
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

  def comandoCas(llave, valores)
    puts("#{valores}")
    if (@datos[llave].valorCas == valores[4])
      chunk = valores.pop()
      valores.pop()
      valores.push(chunk)
      mData = MData.new(valores)
      comandoSet(llave, mData)
      
    else
      puts("EXISTS")
    end

    
  end
end
