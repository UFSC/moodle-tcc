#encoding: utf-8
require 'spec_helper'

describe "Service" do
  describe "POST /reportingservice" do
    it 'should render error with invalid consumer key' do
      post reportingservice_path, { consumer_key: 'wrong_key', user_ids: [2,4] }
      response.body.should have_json_path('error_message')
    end

    it 'should render error without user_ids' do
      post reportingservice_path, { consumer_key: 'consumer_key' }
      response.body.should have_json_path('error_message')
    end
  end

  describe "POST /tcc_definition_service" do
    it 'should render error with invalid consumer key' do
      post tcc_definition_service_path, { consumer_key: 'wrong_key', user_ids: [2,4] }
      response.body.should have_json_path('error_message')
    end

    it 'should render error without user_ids' do
      post tcc_definition_service_path, { consumer_key: 'consumer_key' }
      response.body.should have_json_path('error_message')
    end
  end
end
