require 'spec_helper'

describe LatexChapterDecorator do

  describe '#content' do
    it 'returns a pre-defined empty message for nil content' do
      mock = double(content: nil)
      subject = LatexChapterDecorator.new(mock)

      expect(subject.content).to have_content('nenhum conteúdo')
    end

    it 'returns a pre-defined empty message for empty content' do
      mock = double(content: '')
      subject = LatexChapterDecorator.new(mock)

      expect(subject.content).to have_content('nenhum conteúdo')
    end
  end
end
