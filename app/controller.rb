require_relative "model"
require "json"
require "set"

class NewCaptcha
  attr_accessor :response

  def initialize
    self.response = {}
    captcha = Captcha.new
    self.response[:body] = captcha.to_json
    self.response[:status] = 200
  end

end

class MatchCaptcha
  attr_accessor :request, :response, :captcha

  def initialize(request)
    self.response = {}
    self.request = JSON.parse(request.body)
    self.parse_request
  end

  def parse_request
    self.captcha = Captcha.find(self.request["sentence"], self.request["exclude"])
    if self.captcha
      exclude_set = Set.new(self.request[:exclude])

      correct_answer = captcha.word_freq.select do |key, value|
        ! exclude_set.include?(key)
      end
    end
    if !self.captcha
      self.response[:status] = 404
    elsif correct_answer  == self.request["answer"]
      self.response[:status] = 200
      Captcha.remove(self.request["sentence"], self.request["exclude"])
    else
      self.response[:status] = 400
    end
    self.response[:body] = nil
  end

end
