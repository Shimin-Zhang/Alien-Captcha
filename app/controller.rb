require_relative "model"
class NewCaptcha
  attr_accessor :response

  def initialize
    self.response = {}
    captcha = Captcha.new
    self.response[:body] = captcha.to_json
    self.response[:status] = 200
    self.response
  end

end

class MatchCaptcha

end
