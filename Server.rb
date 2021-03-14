require 'socket'
require_relative 'MenuServer'

class Server
    attr_accessor :servidor, :long
    
    def initialize(host, port, long = 1000000000)
        @servidor = TCPServer.new(host,port)
        puts("el servidor esta corriendou!")
        @long = long
        $stdout.sync = true #desactivamos el output buffer, asi podremos ver el output mientras sucede y no teniendo que cerrar el programa.
        correrServidor()
    end

    def correrServidor
        loop do # el servidor esta ejecutandose permanentemente, aceptando multiples conexiones
    
            Thread.start(@servidor.accept()) do |s|    
                puts(s, " es aceptado!")
                salir = false
                while !salir do
                    s.puts("Bienvenido al Taller RUBY - MEMCACHED EMULATOR\n\n")
                    s.puts("1 -> Correr Memcached emulator")
                    s.puts("2 -> Correr version DEMO con casos de prueba")
                    s.puts("3 -> Correr tests")
                    s.puts("4 -> Salir\n\n")
                    s.puts("Ingresar opcion: ")
                    msg = s.recv(long) 
                    puts("cliente dice: #{msg}\n\n")
                    if(msg == 4)
                        s.puts("Gracias por probar este MEMCACHED EMULATOR. Vuelva pronto! : )")
                        sleep(2)
                        s.kill self
                        salir = true
                    end
                    
                end
                puts(s, " se va!")
                s.close
                
            end
        end
        
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

