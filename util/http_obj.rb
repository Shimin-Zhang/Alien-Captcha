class HttpRequest
  attr_accessor :params, :method, :host, :resource_uri, :body

  def initialize(socket)
    self.params = {} #hash for constant speed lookup

    request_line = socket.gets.strip.split(' ')
    self.method = request_line[0] #Do not care about uri, for now

    while true
      current_line = socket.gets
      break if current_line.strip.empty?
      data = current_line.split(': ')
      self.params[data[0]] = data[1].strip
    end

    if self.params.has_key?('Content-Length')
      #Should add to include all methods, will do for now
      body_length = self.params["Content-Length"].to_i
      self.body = socket.readpartial(body_length)
      #Only took an hour, might want to chunk it up like Mongrel at some pt
    end
  end

end

class HttpResponse
  STATUS = {
    200 => "OK",
    400 => "Bad Request",
    404 => "Not Found"
  }
  attr_reader :response

  def initialize(response)
    @response = response
  end

  def render
    response_string = ''
    status = self.response[:status]
    body = self.response[:body]
    response_string += "HTTP/1.1 #{status} #{HttpResponse::STATUS[status]}\r\n"
    if body
      response_string += "Content-Type: application/json\r\n"
      response_string += "Content-Length: #{body.length}\r\n"
      response_string += "\r\n"
      response_string += body
    end
    response_string
  end
end
