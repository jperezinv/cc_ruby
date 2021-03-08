require 'socket'

servidor = TCPServer.new('localhost', 2000) #abro servidor en el puerto 2000
puts("El servidor esta corriendo!")

$stdout.sync = true #desactivamos el output buffer, asi podremos ver el output mientras sucede y no teniendo que cerrar el programa.

loop do # el servidor esta ejecutandose permanentemente, aceptando multiples conexiones
    
    Thread.start(servidor.accept()) do |cliente| 
    
    until cliente.eof?   
        
        msg = cliente.gets()
        cliente.write(msg)
    end


    end 

end


