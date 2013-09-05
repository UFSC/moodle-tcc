require 'spec_helper'

describe DiaryDefinition do
  it { respond_to :external_id, :order, :position, :title }

  context 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :order }
    it { should validate_presence_of :external_id }
    it { should belong_to :hub_definition }
  end

  it 'should create a valid model' do
    diary = Fabricate.build(:diary_definition)
    diary.should be_valid
  end
end