require 'socket'

class Server
    attr_accessor :socket, :long, :conexiones, :clientes
    
    def initialize(host, port, long = 1000000000)
        
        @socket = TCPServer.new(host,port)
        @conexiones = {}
        @clientes = {}
        @conexiones['servidor'] = @socket
        @conexiones['clientes'] = @clientes
        @long = long
        $stdout.sync = true #desactivamos el output buffer, asi podremos ver el output mientras sucede y no teniendo que cerrar el programa.
        puts("el servidor está escuchando..")
        begin
            correrServidor()
        rescue Errno::EPIPE
            puts ("CAÑO ROTO")
        end
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
            s.puts("Bienvenido al Taller RUBY - MEMCACHED EMULATOR\n\n")
            s.puts("1 -> Correr Memcached emulator")
            s.puts("2 -> Correr version DEMO con casos de prueba")
            s.puts("3 -> Correr tests")
            s.puts("4 -> Salir\n\n")
            s.puts("Ingresar opcion: ")
            msg = s.recv(long).chomp()
            puts(s, " ingreso opcion: #{msg}\n\n")
            case msg
            when '1'
                s.puts("Aca deberia llamar al emulador, pero es lo que estoy intentando averiguar, Mike..")
                next
            when '2'
                s.puts("Aun no esta implementado, Johnny..")
                next
            when '3'
                s.puts("No disponible, Jerry..")
                next
            when '4'
                salir = true
                next
            else
                s.puts("Opcion Incorrecta. Volve a intentarlo.")
                next
            end
        end
        puts("sali del while")
    end
end

servidor = Server.new('localhost', 2000)


=begin
servidor = TCPServer.new('localhost', 2000) #abro servidor en el puerto 2000
puts("El servidor esta corriendo!")
long = 1000000000

$stdout.sync = true #desactivamos el output buffer, asi podremos ver el output mientras sucede y no teniendo que cerrar el programa.


    

loop do # el servidor esta ejecutandose permanentemente, aceptando multiples conexiones
    
    Thread.start(servidor.accept()) do |s|    
        puts(s, " es aceptado!")
        s.puts(Time.now)
        msg = s.recv(long) 
        puts("cliente dice: #{msg}\n\n")
        puts(s, " se va!")
        s.close
    end
end
=end

