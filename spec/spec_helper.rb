ENV['RACK_ENV'] = 'test'

require File.expand_path '../../app', __FILE__
require 'rack/test'
require 'json'

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

module Captcha
  include Rack::Test::Methods
  def get_answer(response)
    body = JSON.parse(response.body)
    sentence = body["sentence"]
    exclude = body["exclude"]
    word_freq = Hash.new(0)
    words = sentence.split(/\W+/).map(&:downcase)
    words.each do |word|
      word_freq[word] += 1 unless exclude.include? word
    end

    post_data = {
      "sentence" => sentence,
      "exclude" => exclude,
      "answer" => word_freq
    }
  end

  def get_incorrect_answer(response)
    correct = get_answer(response)
    key = correct["answer"].keys.sample(1)
    correct["answer"][key] += 1
    correct
  end
end

RSpec.configure { |c| c.include RSpecMixin }
RSpec.configure do |c|
  c.include Captcha
end
