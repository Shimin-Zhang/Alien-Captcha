require "./spec/spec_helper"
require "json"


describe 'The Word Counting App' do
  uri = URI('http://localhost:8000')

  it "returns 200 and has the right keys" do
    response = Net::HTTP.get_response(uri)
    expect(response.code).to eq("200")
    expect(response.message).to eq("OK")
    body = JSON.parse(response.body)
    expect(body.keys).to include('sentence')
    expect(body.keys).to include('exclude')
  end

  it "sends reponse 200 if the correct response is submitted" do
    response = Net::HTTP.get_response(uri)
    answer = get_answer(response)

    Net::HTTP.start(uri.host, uri.port) do |http|
      new_response = http.request_post('/', answer.to_json)
      expect(new_response.code).to eq("200")
      expect(new_response.message).to eq("OK")
    end

  end

  it "sends 404 if we submit the correct answer again" do
    response = Net::HTTP.get_response(uri)
    answer = get_answer(response)

    Net::HTTP.start(uri.host, uri.port) do |http|
      new_response = http.request_post('/', answer.to_json)
      expect(new_response.code).to eq("200")
      expect(new_response.message).to eq("OK")
    end

    Net::HTTP.start(uri.host, uri.port) do |http|
      new_response = http.request_post('/', answer.to_json)
      expect(new_response.code).to eq("404")
      expect(new_response.message).to eq("Not Found")
    end
  end

  it "sends 400 if incorrect numbers are submitted" do
    response = Net::HTTP.get_response(uri)
    answer = get_incorrect_answer(response)

    Net::HTTP.start(uri.host, uri.port) do |http|
      new_response = http.request_post('/', answer.to_json)
      expect(new_response.code).to eq("400")
      expect(new_response.message).to eq("Bad Request")
    end
  end

end
