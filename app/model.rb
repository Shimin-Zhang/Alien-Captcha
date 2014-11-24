require "erb"

class Captcha
  attr_accessor :sentence, :exclude
  def self.find(sentence, exclude)

  end

  def self.build(sentence, exclude) #to be replaced with find version (db)
    captcha = Captcha.new
    captcha.sentence, captcha.exclude = sentence, exclude
    captcha
  end

  def initialize(random = false)
    if random

    else
      num = Random.rand(6)
      #Should be an app wide env variable
      app_path =  File.expand_path(File.dirname(__FILE__))
      self.sentence = File.open("#{app_path}/../texts/#{num}", &:gets).strip
    end
    self.exclude = self.create_exclude
  end

  def word_freq 
    freq = Hash.new(0)
    words = self.sentence.split(/\W+/).map(&:downcase)
    words.each do |word|
      freq[word] += 1
    end
    freq
  end

  def create_exclude
    word_freq = self.word_freq
    uniques = word_freq.keys
    to_sample = uniques.length == 1 ? 0 : Random.rand(uniques.length)
    uniques.sample(to_sample)
  end

  def to_json
    puts 'writting response'
    app_path =  File.expand_path(File.dirname(__FILE__))
    template = File.new("#{app_path}/../views/get.json.erb").read
    ERB.new(template).result(binding)
  end
end
