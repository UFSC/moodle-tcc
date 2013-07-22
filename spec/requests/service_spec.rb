#encoding: utf-8
require 'spec_helper'

describe "Service" do
  describe "POST /reportingservice" do
    it 'should render error with invalid consumer key' do
      expected = {
          error_message: 'Invalid consumer key'
      }.to_json
      post reportingservice_path, { consumer_key: 'wrong_key', user_ids: [2,4] }
      response.body.should == expected
    end

    it 'should render error without user_ids' do
      expected = {
          error_message: 'Invalid params (missing user_ids)'
      }.to_json
      post reportingservice_path, { consumer_key: 'consumer_key' }
      response.body.should == expected
    end
  end
end
