require_relative "../util/http_obj"
require_relative "controller"
class CaptchaApp
  attr_reader :request, :response

  def initialize(request)
    @request = request
    self.route
  end

  def route
    if self.request.method == "GET"
      @response = NewCaptcha.new
    else
      @response = MatchCaptcha.new(self.request)
    end
    HttpResponse.build(self.response)
  end
end
