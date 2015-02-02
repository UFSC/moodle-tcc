module ReferencesUtils
  REFERENCES = {'internet' => 'InternetRef',
                'livros' => 'BookRef',
                'capítulos' => 'BookCapRef',
                'artigos' => 'ArticleRef',
                'legislative' => 'LegislativeRef',
                'tesis' => 'ThesisRef'}

  def self.build_tag_citacao(model, citacao_type, text)
    %(<citacao citacao-text="#{model.title}" citacao_type="#{citacao_type}" class="citacao-class"
contenteditable="false" id="#{model.id}" ref-type="#{ReferencesUtils::REFERENCES.invert[model.class.to_s]}"
title="#{text}" reference_id="#{model.reference.id}">#{text}</citacao>)
  end
end

shared_examples_for 'references with citations in the text' do

  let(:decorated_reference) { reference.decorate }
  let(:prefix) { Faker::Lorem.paragraph(1) }
  let(:sufix) { Faker::Lorem.paragraph(1) }
  let(:citacao) { ReferencesUtils.build_tag_citacao(decorated_reference, 'ci', decorated_reference.indirect_citation) }
  let(:text_with_reference) { "<p>#{prefix}#{citacao}#{sufix}</p>" }
  let(:text_without_reference) { Faker::Lorem.paragraph(1) }

  context 'citation inside abstract' do

    before(:each) do
      @tcc = Fabricate.build(:tcc_with_all)
      @tcc.abstract.content = text_without_reference

      @tcc.abstract.save!
      @tcc.save!
      @tcc.references.create!(element: reference)

      reference.reload
    end

    it 'should allow to delete reference if there is not a citation in the text' do
      count = reference.class.all.size

      reference.destroy
      expect(reference.class.all.size).to eq(count-1)
    end

    it 'should not allow to delete reference if there is a citation in the text' do
      @tcc.abstract.content = text_with_reference
      @tcc.abstract.save!

      count = reference.class.all.size
      reference.destroy
      expect(reference.class.all.size).to eq(count)
    end
  end

  context 'citation inside chapter' do

    before(:each) do
      @tcc = Fabricate.build(:tcc_with_all)
      @chapter = @tcc.chapters.first
      @chapter.content = text_without_reference

      @chapter.save!
      @tcc.save!
      @tcc.references.create!(element: reference)

      reference.reload
    end

    it 'should allow to delete reference if there is not a citation in the text' do
      count = reference.class.all.size
      reference.destroy
      expect(reference.class.all.size).to eq(count-1)
    end

    it 'should not allow to delete reference if there is a citation in the text' do
      @chapter.content = text_with_reference
      @chapter.save!

      count = reference.class.all.size
      reference.destroy
      expect(reference.class.all.size).to eq(count)
    end
  end

end