shared_examples_for 'references with citations in the text' do
  REFERENCES = {'internet' => 'InternetRef',
                'gerais' => 'GeneralRef',
                'livros' => 'BookRef',
                'capítulos' => 'BookCapRef',
                'artigos' => 'ArticleRef',
                'legislative' => 'LegislativeRef'}

  CITACOES = {'cd' => :direct_citation, 'ci' => :indirect_citation}
  let(:prefix) { Faker::Lorem.paragraph(1) }
  let(:sufix) { Faker::Lorem.paragraph(1) }
  let(:citacao) { build_tag_citacao(ref, 'ci', ref.indirect_citation) }
  let(:text) { "<p>#{prefix}#{citacao}#{sufix}</p>" }

  before(:each) do
    ref.save!
    ref.reload
    @tcc = Fabricate.build(:tcc_with_all)
    @tcc.save!
    @tcc.references.create!(element: ref)
  end

  it 'should allow to delete reference if there is not a citation in the text' do
    text_without_reference = Faker::Lorem.paragraph(1)
    @tcc.abstract.content = text_without_reference
    @tcc.abstract.save!
    count = ref.class.all.size
    ref.destroy
    ref.class.all.size.should eq(count-1)

  end

  it 'should not allow to delete reference if there is a citation in the text' do
    @tcc.abstract.content = text
    @tcc.abstract.save!
    count = ref.class.all.size
    ref.destroy
    ref.class.all.size.should eq(count)
  end
  it 'should do nothing if abstract is nil' do
    @tcc.abstract = nil
    @tcc.save!
    count = ref.class.all.size
    ref.destroy
    ref.class.all.size.should eq(count)
  end


end

def build_tag_citacao(model, citacao_type, text)
  %Q(<citacao citacao-text="#{model.title}" citacao_type="#{CITACOES[citacao_type]}"
class="citacao-class" contenteditable="false" id="#{model.id}" ref-type="#{REFERENCES.invert[model.class.to_s]}"
 title="#{text}" reference_id="999">#{text}</citacao>)
end