require 'spec_helper'

describe ChapterDefinition do
  it { should respond_to(:chapters, :coursemodule_id, :position, :title, :tcc_definition) }

  context 'validations' do
    it { should validate_presence_of :position }
    it { should validate_presence_of :tcc_definition }
    it { should validate_presence_of :title }
    it { should belong_to :tcc_definition }
  end

  it 'should create a valid model' do
    chapter = Fabricate.build(:chapter_definition)
    expect(chapter).to be_valid
  end
end
