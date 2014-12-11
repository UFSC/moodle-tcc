#encoding: utf-8
require 'spec_helper'

describe "Service" do
  describe "POST /reportingservice_tcc" do
    it 'should render error with invalid consumer key' do
      post reportingservice_tcc_path, { consumer_key: 'wrong_key', user_ids: [2,4] }
      expect(response.body).to have_json_path('error_message')
    end

    it 'should render error without user_ids' do
      post reportingservice_tcc_path, { consumer_key: 'consumer_key' }
      expect(response.body).to have_json_path('error_message')
    end
  end

  describe "POST /tcc_definition_service" do
    it 'should render error with invalid consumer key' do
      post tcc_definition_service_path, { consumer_key: 'wrong_key', user_ids: [2,4] }
      expect(response.body).to have_json_path('error_message')
    end

    it 'should render error without user_ids' do
      post tcc_definition_service_path, { consumer_key: 'consumer_key' }
      expect(response.body).to have_json_path('error_message')
    end
  end
end
