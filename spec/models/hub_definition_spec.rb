require 'spec_helper'

describe HubDefinition do
  context 'validations' do
    it { should validate_presence_of :order }
    it { should validate_presence_of :tcc_definition }
    it { should validate_presence_of :title }
    it { should belong_to :tcc_definition }
  end

  it 'should create a valid model' do
    hub = Fabricate.build(:hub_definition)
    hub.should be_valid
  end
end
