module ReferencesUtils
  REFERENCES = {'internet' => 'InternetRef',
                'gerais' => 'GeneralRef',
                'livros' => 'BookRef',
                'capítulos' => 'BookCapRef',
                'artigos' => 'ArticleRef',
                'legislative' => 'LegislativeRef'}

  CLASSES_STRINGS = ['abstract', 'presentation', 'final_considerations']
end

shared_examples_for 'references with citations in the text' do

  before(:each) do
    @ref = ref.decorate
  end
  
  let(:prefix) { Faker::Lorem.paragraph(1) }
  let(:sufix) { Faker::Lorem.paragraph(1) }
  let(:citacao) { build_tag_citacao(@ref, 'ci', @ref.indirect_citation) }
  let(:text) { "<p>#{prefix}#{citacao}#{sufix}</p>" }
  let(:text_without_reference) { Faker::Lorem.paragraph(1) }

  before(:each) do
    ref.save!
    ref.reload

    @tcc = Fabricate.build(:tcc_with_all)
    @tcc.abstract.content = text_without_reference
    @tcc.presentation.content = text_without_reference
    @tcc.final_considerations.content = text_without_reference

    @tcc.abstract.save!
    @tcc.presentation.save!
    @tcc.final_considerations.save!
    @tcc.save!
    @tcc.references.create!(element: ref)
  end


  ReferencesUtils::CLASSES_STRINGS.each do |string|
    it 'should allow to delete reference if there is not a citation in the text' do
      @tcc.send("#{string}=", nil)
      @tcc.save!

      count = ref.class.all.size
      ref.destroy
      expect(ref.class.all.size).to eq(count-1)
    end
  end

  ReferencesUtils::CLASSES_STRINGS.each do |string|
    it 'should not allow to delete reference if there is a citation in the text' do
      @tcc.abstract.content = text
      @tcc.presentation.content = text
      @tcc.final_considerations.content = text

      @tcc.abstract.save!
      @tcc.presentation.save!
      @tcc.final_considerations.save!

      @tcc.send("#{string}=", nil)
      @tcc.save!

      count = ref.class.all.size
      ref.destroy
      expect(ref.class.all.size).to eq(count)
    end
  end

end

def build_tag_citacao(model, citacao_type, text)
  %Q(<citacao citacao-text="#{model.title}" citacao_type="#{citacao_type}"
class="citacao-class" contenteditable="false" id="#{model.id}" ref-type="#{ReferencesUtils::REFERENCES.invert[model.class.to_s]}"
 title="#{text}" reference_id="999">#{text}</citacao>)
end