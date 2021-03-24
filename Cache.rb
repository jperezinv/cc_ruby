require_relative 'MenuCache'
require_relative 'MData'

class Cache
  attr_accessor :maxTamanio, :datos, :tokenCas

  def initialize(maxTamanio = 10, tokenCas = 1)
    @datos = {} #el ultimo sera el primero en el LRU
    @maxTamanio = maxTamanio
    @tokenCas = tokenCas
  end

  #FUNCIONES AUXILIARES

  def soloNum(string) #Devuelve true si el string contiene digitos o esta vacio, sino devuelve false
    string.scan(/\D/).empty?
  end

  def getHash
    return @datos.to_a.reverse
  end

  
  #Esta funcion parsea el arreglo y separa por espacios, devolviendo un arreglo con 
  #cada parte de la linea del comando separada 
  def datosToArray(comandos, chunk) 
    
    if (comandos[4].to_i < chunk.length) #auxArr[4] representa los bytes del chunk.
      return nil   
    elsif !soloNum(comandos[4]) 
      return nil
    elsif !soloNum(comandos[3])
      return nil
    elsif !soloNum(comandos[2])
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

  def stringToArray(string) 
    return string.split(" ")
  end

  def controlTiempo(auxHash) #recibe la coleccion de llaves de el emulador memcached
    
    if auxHash.length > 0
      auxHash.each do |llave, valor|
        if auxHash[llave].exp_time != 0 && Time.now >= auxHash[llave].exp_time 
          auxHash.delete(llave)
        end
      end
    end
  
  end
  

  #COMANDOS

  def comandoGet(llaves) #recibe una/s key/s y devuelve el/los valor/valores
  
    if @datos.empty?
      return "AUN NO HAY KEYS GUARDADAS EN MEMORIA."
    end
    
    data = []
    cont = 0
    
    if llaves.length > 0
      llaves.each do |llave|
        for k in @datos.keys
          if k == llave
            borrado = @datos.delete(k) #borro y obtengo el valor borrado
            @datos[k] = borrado #lo vuelvo a insertar con esa misma llave, ya que se accedió recientemente.
            data[cont] = "VALUE #{k} #{@datos[k].flag} #{@datos[k].bytes}\r\n #{@datos[k].chunk}"  #despues guardo el par key-valor en el array que retornaré al final 
            cont += 1
          end    
        end
      end
    end

    if !data.empty? #si no esta vacio, devuelvo el array con los valores que tenga
      return data #el output sera VALUE seguido de la KEY y el VALOR
    else
      return ("NOT_STORED") #si esta vacio entonces devuelvo nil
    end
  
  end

  def comandoSet(llave, data) #recibe una key y una instancia de 'MData', que guardara en el hash.
    @datos.delete(llave) #borro lo que este con esa llave
    @datos[llave] = data #e inserto al final

    if @datos.length > maxTamanio
      @datos.delete(@datos.keys[0]) #si el tamaño es mayor al maxTamanio, borro el primer elemento del hash (el de menos relevancia)
    end
    
    return ("STORED") #output será STORED
  
  end

  def comandoAdd (llave, valores)
    if @datos.key?(llave)
      auxArr = [llave]
      return comandoGet(auxArr) 
    end
    mData = MData.new(valores)
    comandoSet(llave,mData)
  end

  def comandoReplace(llave, valores)
    if @datos.key?(llave)
      @datos[llave].bytes = valores[3]
      @datos[llave].chunk = valores[4]
      return "STORED"
    else 
      return "NOT_STORED"
    end
  end

  def comandoAppend(llave, valores)
    if @datos.key?(llave) 
      aux = bytesCheck(llave, valores[4])
      if (aux == nil)
        return "ERROR"
      end    
      @datos[llave].chunk = @datos[llave].chunk+valores[4]
      return "STORED"
    else
      return "NOT_STORED"
    end
  end

  def comandoPrepend(llave, valores)
    if @datos.key?(llave) 
      aux = bytesCheck(llave, valores[4])
      if (aux == nil)
        return "ERROR"        
      end    
      @datos[llave].chunk = valores[4]+@datos[llave].chunk 
      return "STORED"
    else
      return "NOT_STORED"
    end

  end

  def comandoGets(llaves)
    if @datos.empty?
      return "AUN NO HAY KEYS GUARDADAS EN MEMORIA."
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
      return data #el output sera VALUE seguido de la KEY y el VALOR
    else
      return "NOT_STORED" #si esta vacio entonces devuelvo nil
    end
  end

  def comandoCas(llave, valores)
    if(@datos.key?(llave))
      if (@datos[llave].valorCas == valores[4])
        chunk = valores.pop()
        valores.pop()
        valores.push(chunk)
        mData = MData.new(valores)
        comandoSet(llave, mData)
        
      else
        return "EXISTS"
      end
    else
      return "NOT_FOUND"
    end
      

    
  end
end
