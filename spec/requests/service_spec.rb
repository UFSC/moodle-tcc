#encoding: utf-8
require 'spec_helper'

describe "Service" do
  describe "POST /reportingservice" do
    before(:all) do
      @host = 'http://127.0.0.1:3000/reportingservice'
    end

    it 'should render error with invalid consumer key' do
      expected = {
          error_message: 'Invalid consumer key'
      }.to_json
      response = RestClient.post @host, consumer_key: 'wrong_key', user_ids: [2,4]
      response.body.should == expected
    end

    it 'should render error without user_ids' do
      expected = {
          error_message: 'Invalid params (missing user_ids)'
      }.to_json
      response = RestClient.post @host, consumer_key: 'consumer_key'
      response.body.should == expected
    end
  end
end
