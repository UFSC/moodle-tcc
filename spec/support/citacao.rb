# encoding: utf-8
shared_examples_for 'indirect_citation' do
  before(:each) do
    if(ref.class == BookRef || ref.class == BookCapRef || ref.class == InternetRef)
      @ref = GenericReferenceDecorator.new(ref)
    else
      @ref = ref
    end
    @ref.first_author = 'Alguma coisã qué deve ser ignorada GESTÃO'
  end


  it 'should include author' do
    lastname = UnicodeUtils.titlecase(ref.first_author.split(' ').last)
    expect(@ref.indirect_citation).to include(lastname)
  end

  it 'should include year' do
    expect(@ref.indirect_citation).to include(@ref.year.to_s)
  end

  it 'should include (' do
    expect(@ref.indirect_citation).to include('(')
  end

  it 'should include )' do
    expect(@ref.indirect_citation).to include(')')
  end

  it 'should capitalize correctly' do
    text = "Gestão (#{@ref.year})"
    expect(@ref.indirect_citation).to eq(text)
  end

end

shared_examples_for 'indirect_citation with more than one author' do

  before(:each) do
    if(ref.class == BookRef || ref.class == BookCapRef || ref.class == InternetRef)
      @ref = GenericReferenceDecorator.new(ref)
    else
      @ref = ref
    end
  end

  it 'should capitalize correctly with three authors' do
    @ref.first_author = 'Alguma coisã qué deve ser ignorada GESTÃO'
    @ref.second_author = 'Alguma coisã qué deve ser ignorada GESTÃO'
    @ref.third_author = 'Alguma coisã qué deve ser ignorada GESTÃO'

    text = "Gestão, Gestão e Gestão (#{@ref.year})"
    expect(@ref.indirect_citation).to eq(text)
  end
  it 'should capitalize correctly with two authors' do
    @ref.first_author = 'Alguma coisã qué deve ser ignorada GESTÃO'
    @ref.second_author = 'Alguma coisã qué deve ser ignorada GESTÃO'
    @ref.third_author = ''

    text = "Gestão e Gestão (#{@ref.year})"
    expect(@ref.indirect_citation).to eq(text)
  end
  it 'should capitalize correctly with one author' do
    @ref.first_author = 'Alguma coisã qué deve ser ignorada GESTÃO'
    @ref.second_author = ''
    @ref.third_author = ''

    text = "Gestão (#{@ref.year})"
    expect(@ref.indirect_citation).to eq(text)
  end

  it 'should include year' do
    expect(@ref.indirect_citation).to include(@ref.year.to_s)
  end

  it 'should include (' do
    expect(@ref.indirect_citation).to include('(')
  end

  it 'should include )' do
    expect(@ref.indirect_citation).to include(')')
  end

end
