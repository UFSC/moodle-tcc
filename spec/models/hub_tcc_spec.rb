require 'spec_helper'

describe HubTcc do
  let(:hub) { Fabricate.build(:hub_tcc) }
  let(:tcc) { Fabricate.build(:tcc_with_definitions) }
end