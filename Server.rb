require 'socket'
require_relative 'Cache'
require_relative 'MenuCache'
require_relative 'MData'
require_relative 'Demo'

class Server
    attr_accessor :socket, :long, :cache
    
    def initialize(host, port, long = 1000000000)
        
        @socket = TCPServer.new(host,port)
        @cache = Cache.new()
        @long = long
        $stdout.sync = true #desactivamos el output buffer, asi podremos ver el output mientras sucede y no teniendo que cerrar el programa.
        puts("el servidor está escuchando en el puerto #{port}..")
        correrServidor()
    
    end

    def correrServidor
        loop do # el servidor esta ejecutandose permanentemente, aceptando multiples conexiones
    
            Thread.start(@socket.accept()) do |s|    
                puts(s, " es bienvenido")
                menuServer(s)
                s.close
            end
        end
        
    end

    def menuServer(s)
        
        salir = false
        while !salir do
            s.puts("\u001B[2J") 
            s.puts("Bienvenido al Taller RUBY: MEMCACHED EMULATOR\n\n")
            s.puts("1 -> Correr Memcached emulator")
            s.puts("2 -> Correr version DEMO con casos de prueba")
            s.puts("3 -> Correr tests")
            s.puts("4 -> Salir\n\n")
            s.puts("Ingrese una opcion: ")
            msg = s.recv(long).chomp()
            puts(s, " ingreso opcion: #{msg}\n\n")
            case msg
            when '1'
                s.puts("\u001B[2J") #limpia pantalla en telnet
                MenuCache.menu(@cache, s)
                next
            when '2'
                s.puts("\u001B[2J")          
                Demo.correrCasos(@cache, s)
                next
            when '3'
                s.puts("No disponible, Jerry..")
                sleep(2)
                next
            when '4'
                salir = true
                next
            else
                s.puts("Opcion Incorrecta. Volve a intentarlo.")
                sleep(5)
                next
            end

        end
        puts("sali del while")
    end
end

servidor = Server.new('localhost', 2000)


