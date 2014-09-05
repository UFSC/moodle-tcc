require 'spec_helper'

describe Hub do
  let!(:hub) { Fabricate(:hub) }
  let(:hub_tcc) { Fabricate(:hub_tcc) }

  it { should respond_to(:position, :reflection, :reflection_title) }
end
