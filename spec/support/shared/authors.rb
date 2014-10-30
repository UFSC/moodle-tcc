shared_examples_for 'authors with first and lastname' do
  it 'should have last name' do
    ref.first_author = 'firstname'
    expect(ref).not_to be_valid
    ref.first_author = 'firstname lastname'
    expect(ref).to be_valid
  end

  it 'should have last name' do
    ref.second_author = 'firstname'
    expect(ref).not_to be_valid
    ref.second_author = 'firstname lastname'
    expect(ref).to be_valid
  end

  it 'should have last name' do
    ref.third_author = 'firstname'
    expect(ref).not_to be_valid
    ref.third_author = 'firstname lastname'
    expect(ref).to be_valid
  end
end