describe UnicodeUtils do


  shared_examples_for 'indirect_citation' do
    before(:each) do
      ref.first_author = 'GESTÃO Alguma coisã qué deve ser ignorada'
    end

    it 'should capitalize correctly' do
      text = "Gestão (#{ref.year})"
      expect(ref.indirect_citation).to eq(text)
    end

  end

  shared_examples_for 'indirect_citation with more than one author' do
    before(:each) do
      ref.first_author = 'GESTÃO'
      ref.second_author = 'GESTÃO'
      ref.third_author = 'GESTÃO'
    end

    it 'should capitalize correctly' do
      text = "Gestão, Gestão e Gestão (#{ref.year})"
      expect(ref.indirect_citation).to eq(text)
    end

  end
end
