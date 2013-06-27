require 'spec_helper'

describe DiaryDefinition do
  context 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :order }
    it { should validate_presence_of :external_id }
    it { should belong_to :hub_definition }
  end
end
