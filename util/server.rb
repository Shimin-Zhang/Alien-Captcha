require 'socket'
require_relative 'http_obj'
require_relative '../app/app'

class Server
  def start(host = 'localhost', port = 8000)
    puts "starting new server at #{host}, port #{port}"
    server = TCPServer.new(host, port)
    while true
      Thread.start(server.accept) do |socket| #Threads are less blocking
        request = HttpRequest.new(socket)
        app = CaptchaApp.new(request)
        socket.puts app.render
        socket.close
      end
    end
  end
end

Server.new.start
