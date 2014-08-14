#encoding: utf-8
require 'spec_helper'

describe HubsHelper do
  describe '#diary_content' do
    it 'should return a error message when content is empty' do
      helper.diary_content('').should include('não existe nada postado')
    end

    it 'should return the content when its not empty' do
      helper.diary_content('alguma coisa').should == 'alguma coisa'
    end

    it 'should return a html_safe content' do
      helper.diary_content('<strong>algumacoisa</strong>').html_safe?.should be true
    end
  end
end
