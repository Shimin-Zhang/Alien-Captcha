require_relative "../util/http_obj"
require_relative "controller"
class CaptchaApp

  attr_reader :request, :response, :controller

  def initialize(request)
    @request = request
    self.route
  end

  def route
    if self.request.method == "GET"
      @controller = NewCaptcha.new
    else
      @controller = MatchCaptcha.new(self.request)
    end
  end

  def render
      HttpResponse.new(@controller.response).render
  end

end
