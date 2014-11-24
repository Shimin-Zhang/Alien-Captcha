class HttpRequest
  def self.Build(socket)
    request = HttpRequest.new
    request_line = socket.gets.strip.split(' ')
    request.method = request_line[0] #Do not care about uri, for now
    while true
      current_line = socket.gets
      break if current_line.strip.empty?
      data = current_line.split(': ')
      request.params[data[0]] = data[1].strip
    end

    if request.method == "POST"
      #Should add to include all methods, will do for now
      body_length = request.params["Content-Length"].to_i
      request.body = socket.readpartial(body_length)
      #Only took an hour, might want to chunk it up like Mongrel at some pt
    end
    request
  end

  attr_accessor :params, :method, :host, :resource_uri, :body

  def initialize
    self.params = {} #hash for constant speed lookup
  end
end

class HttpResponse
  def self.Build(response)

  end
end
