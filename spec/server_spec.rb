require 'net/http'
require "json"
server_uri = URI('http://localhost:8000')
resrouce = Net::HTTP.start(server_uri.hostname, server_uri.port) do |http|
  request = Net::HTTP::Post.new(server_uri)
  request.body = ("{'name': 'john'}")
  http.request(request)
end

describe "the word count captcha"

end
