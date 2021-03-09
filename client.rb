require 'socket' 

socket = TCPSocket.new("127.0.0.1", 2000) 
long = 1000000000
msg = socket.recv(long)
puts("El mensaje enviado por el servidor: #{msg}\n\n")

puts("ingrese un mensaje que quiera mandar al servidor: ")
aux = gets.chomp()
socket.puts(aux)
  
socket.close