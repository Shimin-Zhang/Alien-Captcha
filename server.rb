require 'socket'


class Server
  def start(host = 'localhost', port = 8000)
    puts "starting new server at #{host}, port #{port}"
    server = TCPServer.new(host, port)
    while true
      Thread.start(server.accept) do |socket|
        puts "new request received"
        puts socket.gets
        response = "Hulk Smash!\n"
        socket.puts response
        socket.close
      end
    end
  end
end

Server.new.start
