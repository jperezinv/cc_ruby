require 'socket'
require_relative 'menu'

servidor = TCPServer.new('localhost', 2000) #abro servidor en el puerto 2000
puts("El servidor esta corriendo!")
long = 1000000000

$stdout.sync = true #desactivamos el output buffer, asi podremos ver el output mientras sucede y no teniendo que cerrar el programa.

loop do # el servidor esta ejecutandose permanentemente, aceptando multiples conexiones
    
    Thread.start(servidor.accept()) do |s|    
        print(s, " es aceptado!\n")
        s.puts("hola! estoy aprendiendo a comunicarme entre servidor y socket. mensaje enviado desde el servidor")
        aux = s.recv(long)
        puts("El mensaje enviado por el socket: #{aux}\n\n")
        puts(s, " se va!\n")
        s.close
    end
end


def menuServer
    s.puts("Bienvenido al Taller RUBY - MEMCACHED EMULATOR\n\n")
    s.puts("1 -> Correr Memcached emulator")
    s.puts("2 -> Correr version DEMO con casos de prueba")
    s.puts("3 -> Correr tests")
    s.puts("4 -> Salir\n\n")
    s.puts("Ingresar opcion: ")
end