require_relative 'MenuCache'
require_relative 'MData'

class Cache
  attr_accessor :maxTamanio, :datos

  def initialize(maxTamanio = 5, tokenCas = 1)
    @datos = {} #el ultimo sera el primero en el LRU
    @maxTamanio = maxTamanio
  end

  #FUNCIONES AUXILIARES

  def soloNum(string) #Devuelve true si el string contiene digitos o esta vacio, sino devuelve false
    string.scan(/\D/).empty?
  end

  def getHash
    return @datos.to_a.reverse
  end

  
  #Esta funcion realiza un check al arreglo con los comandos ingresados, devolviendo un arreglo con 
  #junto con el chunk, si es que pasa los checks. sino devolverá NIL. 
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

  #Funcion auxiliar de checkeo para los comandos prepend y append.
  #Compara el largo del texto a ingresar + el texto del chunk asociado, y es si es mayor a los bytes de la key, devuelve nil. sino, devuelve el texto 
  def bytesCheck(llave, texto)
    bytes = @datos[llave].bytes
    value = @datos[llave].chunk
    if (bytes.to_i < texto.length + value.length)
      return nil
    else
      return texto
    end
  end

  #Funcion auxiliar para splitear el string a un arreglo, separado por espacios.
  def stringToArray(string) 
    return string.split(" ")
  end

  def controlTiempo #recibe la coleccion de datos de el emulador memcached
    
    if @datos.length > 0
      @datos.each do |llave, valor|
        if @datos[llave].exp_time != 0 && Time.now >= @datos[llave].exp_time #si la llave es distinta de 0 y el tiempo expiró, entonces borro la key del hash.
          @datos.delete(llave)
          return true
        end
      end
    end
    
    return false
  

  end
  

  #COMANDOS

  def comandoGet(llaves) #recibe una/s key/s y devuelve el/los valor/valores
    
    controlTiempo()
    
    if @datos.empty?
      return "AUN NO HAY KEYS GUARDADAS EN MEMORIA."
    end
    
    data = []
    cont = 0
    
    llaves.each do |llave|
      if @datos.key?(llave)
        borrado = @datos.delete(llave) #borro y obtengo el valor borrado
        @datos[llave] = borrado #lo vuelvo a insertar con esa misma llave, ya que se accedió recientemente.
        data[cont] = "VALUE #{llave} #{@datos[llave].flag} #{@datos[llave].bytes}\r\n #{@datos[llave].chunk}"  #despues guardo el par key-valor en el array que retornaré al final 
        cont += 1
      end  
    end
    
    data.push("END\r\n")

    return data #el output sera VALUE seguido de la KEY y el VALOR
    
  
  end

  def comandoSet(llave, data) #recibe una key y una instancia de 'MData', que guardara en el hash.
    @datos.delete(llave) #borro lo que este con esa llave
    @datos[llave] = data #e inserto al final

    if @datos.length > maxTamanio
      @datos.delete(@datos.keys[0]) #si el tamaño es mayor al maxTamanio, borro el primer elemento del hash (el de menos relevancia)
    end
    
    return ("STORED") #output será STORED
  
  end

  def comandoAdd (llave, valores) #recibe una key y si no existe, la agrega, sino devuelve el valor de la key existente.

    controlTiempo()

    if @datos.key?(llave)
      return "NOT_STORED" 
    end
    mData = MData.new(valores)
    comandoSet(llave,mData)
  end

  def comandoReplace(llave, valores) #recibe una key y reemplaza su chunk y los bytes del mismo
    
    controlTiempo()
    
    if @datos.key?(llave)
      @datos[llave].bytes = valores[3]
      @datos[llave].chunk = valores[4]
      @datos[llave].valorCas += 1
      return "STORED"
    else 
      return "NOT_STORED"
    end
  end

  #recibe una key y agrega texto despues del chunk. 
  #se hace un checkeo del largo de texto y bytes con el comando bytes check
  def comandoAppend(llave, valores) 
    
    controlTiempo()

    if @datos.key?(llave) 
      aux = bytesCheck(llave, valores[4])
      if (aux == nil)
        return "ERROR"
      end    
      @datos[llave].chunk = @datos[llave].chunk+valores[4]
      @datos[llave].valorCas += 1
      return "STORED"
    else
      return "NOT_STORED"
    end
  end

  #lo mismo que append pero el texto se coloca antes del chunk.
  def comandoPrepend(llave, valores)

    controlTiempo()

    if @datos.key?(llave) 
      aux = bytesCheck(llave, valores[4])
      if (aux == nil)
        return "ERROR"        
      end    
      @datos[llave].chunk = valores[4]+@datos[llave].chunk
      @datos[llave].valorCas += 1
      return "STORED"
    else
      return "NOT_STORED"
    end

  end

  def comandoGets(llaves) #recibe una/s key/s y devuelve su valor junto con el valor del token cas asociado a cada key
    
    controlTiempo()
    
    if @datos.empty?
      return "AUN NO HAY KEYS GUARDADAS EN MEMORIA."
    end
    
    data = []
    cont = 0
    
    if llaves.length > 0
      llaves.each do |llave|
        if @datos.key?(llave)
          borrado = @datos.delete(llave) #borro y obtengo el valor borrado
          @datos[llave] = borrado #lo vuelvo a insertar con esa misma llave, ya que se accedió recientemente.
          data[cont] = "VALUE #{llave} #{@datos[llave].flag} #{@datos[llave].bytes} #{@datos[llave].valorCas}\r\n #{@datos[llave].chunk}" 
          cont += 1
        end    
      end
    end
    
    data.push("END\r\n")
    
    return data
 
  end

  def comandoCas(llave, valores) #funciona como un set, pero solo si el usuario ingresa el token cas correspondiente a la key que quiere re-setear.
    
    controlTiempo()
    
    if (@datos.key?(llave))
      if (@datos[llave].valorCas == valores[4].to_i) #si el valor cas coincide,
        
        chunk = valores.pop() #quito el chunk del array y lo obtengo
        valores.pop()
        valores.push(chunk) #arriba quito el token cas porque ya no lo necesito para sobreeescribir la nueva key. el valor CAS de la nueva key sera NIL.
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
