require 'socket' 

socket = TCPSocket.new("localhost", 2000) 
long = 1000000000


while msg = socket.recv(long) do
    puts("#{msg}")
end

aux = gets.chomp()
socket.puts(aux)
