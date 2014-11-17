# encoding: utf-8
shared_examples_for 'indirect_citation' do

  let (:decorated_reference) { ref.decorate }

  before(:each) do
    decorated_reference.first_author = 'Alguma coisã qué deve ser ignorada GESTÃO'
    decorated_reference.second_author = ''
    decorated_reference.third_author = ''
  end

  it 'should include author' do
    lastname = UnicodeUtils.titlecase(ref.first_author.split(' ').last)
    expect(decorated_reference.indirect_citation).to include(lastname)
  end

  it 'should include year' do
    expect(decorated_reference.indirect_citation).to include(decorated_reference.year.to_s)
  end

  it 'should include (' do
    expect(decorated_reference.indirect_citation).to include('(')
  end

  it 'should include )' do
    expect(decorated_reference.indirect_citation).to include(')')
  end

  it 'should capitalize correctly' do
    text = "Gestão (#{decorated_reference.year})"
    expect(decorated_reference.indirect_citation).to eq(text)
  end

end

shared_examples_for 'indirect_citation with more than one author' do

  let (:decorated_reference) { ref.decorate }

  it 'should capitalize correctly with three authors' do
    decorated_reference.first_author = 'Alguma coisã qué deve ser ignorada GESTÃO'
    decorated_reference.second_author = 'Alguma coisã qué deve ser ignorada GESTÃO'
    decorated_reference.third_author = 'Alguma coisã qué deve ser ignorada GESTÃO'

    text = "Gestão, Gestão e Gestão (#{decorated_reference.year})"
    expect(decorated_reference.indirect_citation).to eq(text)
  end
  it 'should capitalize correctly with two authors' do
    decorated_reference.first_author = 'Alguma coisã qué deve ser ignorada GESTÃO'
    decorated_reference.second_author = 'Alguma coisã qué deve ser ignorada GESTÃO'
    decorated_reference.third_author = ''

    text = "Gestão e Gestão (#{decorated_reference.year})"
    expect(decorated_reference.indirect_citation).to eq(text)
  end
  it 'should capitalize correctly with one author' do
    decorated_reference.first_author = 'Alguma coisã qué deve ser ignorada GESTÃO'
    decorated_reference.second_author = ''
    decorated_reference.third_author = ''

    text = "Gestão (#{decorated_reference.year})"
    expect(decorated_reference.indirect_citation).to eq(text)
  end

  it 'should include year' do
    expect(decorated_reference.indirect_citation).to include(decorated_reference.year.to_s)
  end

  it 'should include (' do
    expect(decorated_reference.indirect_citation).to include('(')
  end

  it 'should include )' do
    expect(decorated_reference.indirect_citation).to include(')')
  end

end
