#encoding: utf-8
require 'spec_helper'

describe ChaptersHelper do
  describe '#diary_content' do
    it 'should return a error message when content is empty' do
      expect(helper.diary_content('')).to include('não existe nada postado')
    end

    it 'should return the content when its not empty' do
      expect(helper.diary_content('alguma coisa')).to eq('alguma coisa')
    end

    it 'should return a html_safe content' do
      expect(helper.diary_content('<strong>algumacoisa</strong>').html_safe?).to be true
    end
  end
end
