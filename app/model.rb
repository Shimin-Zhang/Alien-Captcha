require "erb"
require 'mongo'
include Mongo


class Captcha
  attr_accessor :sentence, :exclude
  def self.find(sentence, exclude)
    client = MongoClient.new
    captchas = client['db']['captchas']
    item = captchas.find_one({ sentence: sentence, exclude: exclude })
    puts item
    if item
      self.build(sentence, exclude)
    else
      nil
    end
  end

  def self.remove(sentence, exclude)
    client = MongoClient.new
    captchas = client['db']['captchas']
    puts "remove called"
    puts sentence
    puts exclude
    item = captchas.remove(
      { sentence: sentence, exclude: exclude }, { limit: 1})
  end

  def self.build(sentence, exclude) #to be replaced with find version (db)
    captcha = Captcha.new
    captcha.sentence, captcha.exclude = sentence, exclude
    captcha
  end

  def initialize(is_new = false)
    num = Random.rand(6)

    #Should be an app wide env variable
    app_path =  File.expand_path(File.dirname(__FILE__))
    self.sentence = File.open("#{app_path}/../texts/#{num}", &:gets).strip
    self.exclude = self.create_exclude

    # Probably best to add a unique ID to db instead of search by sentence/excl
    if is_new
      client = MongoClient.new
      captchas = client['db']['captchas']
      captchas.insert({ sentence: self.sentence, exclude: self.exclude })
    end
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
