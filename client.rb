require 'socket' 

socket = TCPSocket.new('localhost', 2000) 
long = 1000000000
$stdout.sync = true

    while msg = socket.recv(long).chomp do 
        if msg.empty?
            socket.close
            break
        else
            puts("#{msg}")
            aux = gets.chomp()
            if(aux == "\n")
                aux.chomp()
            end
            socket.puts(aux)
        end
    end



