require 'spec_helper'

describe TccDefinition do

  context 'validations' do
    it { should respond_to :internal_name, :activity_url, :course_id, :defense_date, :chapter_definitions, :tccs }
    it { should validate_presence_of :internal_name }
    it { should validate_uniqueness_of :course_id }
  end

  it 'should create a valid model' do
    tcc = Fabricate.build(:tcc_definition)
    expect(tcc).to be_valid
  end
end
