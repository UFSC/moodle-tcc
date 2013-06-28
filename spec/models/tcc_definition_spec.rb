require 'spec_helper'

describe TccDefinition do
  context 'validations' do
    it { should validate_presence_of :title }
  end

  it 'should create a valid model' do
    tcc = Fabricate.build(:tcc_definition)
    tcc.should be_valid
  end
end
