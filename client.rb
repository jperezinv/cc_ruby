require 'socket' 

socket = TCPSocket.new('localhost', 2000) 

socket.write("hola")
puts socket.gets()
  
socket.close