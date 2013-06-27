require 'spec_helper'

describe HubDefinition do
  context 'validations' do
    it { should validate_presence_of :external_id }
    it { should validate_presence_of :order }
    it { should validate_presence_of :tcc_definition }
    it { should validate_presence_of :title }
  end
end
