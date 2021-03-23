# Memcached Emulator 1.0.0
```
    __  ___                               __             __   ______                __      __            
   /  |/  /__  ____ ___  _________ ______/ /_  ___  ____/ /  / ____/___ ___  __  __/ /___ _/ /_____  _____
  / /|_/ / _ \/ __ `__ \/ ___/ __ `/ ___/ __ \/ _ \/ __  /  / __/ / __ `__ \/ / / / / __ `/ __/ __ \/ ___/
 / /  / /  __/ / / / / / /__/ /_/ / /__/ / / /  __/ /_/ /  / /___/ / / / / / /_/ / / /_/ / /_/ /_/ / /    
/_/  /_/\___/_/ /_/ /_/\___/\__,_/\___/_/ /_/\___/\__,_/  /_____/_/ /_/ /_/\__,_/_/\__,_/\__/\____/_/     
                                                                                                          
```
## About
Memcached Emulator is a Ruby based program that mimics the behaviour of the true memory caching system. It was designed as a TCP/IP Server which handles multiple client connections.

Telnet was used during the implementation of this emulator, to connect to the same port that the server was 'listening'. It is recommended that you use it when trying this emulator 

flags, exptime, bytes  in the command line are supported. Keys will expire when the exptime reaches it's limit.

About Memcached (From the official webpage):
> Free & open source, high-performance, distributed memory object caching system, generic in nature, but intended for use in speeding up dynamic web applications by alleviating database load.

The subset of memcached supported commands are the following: 

- get
- gets
- set
- add
- replace
- append
- prepend
- cas

## Examples

a set command line:
```
set mykey 0 0 100
Hola! probando memcached emulator
```
this will set the key 'mykey', with flag 0, exptime 0 (meaning it will never expire until you close the program) and bytes 100 (the length of the data chunk), to its value pair 'Hola! probando memcached emulator"

a get command line:
```
get mykey
```
this will return info of the key-value pair we are getting (mykey) in this format:

```
mykey 0 100
 Hola! probando memcached emulator
```                                                                                                       


## How to

### Run the program

DISCLAIMER: It is recommended that you use telnet to connect to the server. You can install it from the Ubuntu terminal using the apt-get command.)

Once you download the 1.0.0 version, simply execute the Server.rb file. It will display this message: "el servidor está escuchando en el puerto 2000.." meaning the server is 'listening' in port 2000.
Then, open the terminal and type: "telnet localhost 2000". You will now be looking at the memcached menu. To run the emulator, simply select option 1 on the menu "1 -> Correr Memcached emulator".

### Run the sample commands

A set of simple command lines has been hardcoded so the client can actually see the behaviour of the emulator before running it for the first time. This DEMO shows the commands and chunks entered as well as their respective data outputs.
To run this, simply select option 2 on the menu: "2 -> Correr version DEMO con casos de prueba".

### Run the tests

DISCLAIMER: you **MUST** install the Rspec gem to run this tests.

Rspec was the only ruby gem used in this project. The specs included in this version tests the multiple memcached emulator commands, as well as some auxiliary functions.
To run the specs, open the terminal and navigate to the folder containg the downloaded project folder using the cd command (most likely will be in Downloads or similar). 

Once there, just type: 
```
rbspec name_of_project_folder 
```
That command will run all the files that end with _spec.rb in that folder.

If you wish to run a specific spec, simply navigate to the download project folder and type: 
```
rspec name_of_the_file.rb
```




