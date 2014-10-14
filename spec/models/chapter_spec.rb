require 'spec_helper'

describe Chapter do
  let!(:chapter) { Fabricate(:chapter) }
  let(:hub_tcc) { Fabricate(:hub_tcc) }

  it { should respond_to(:chapter_definition, :content, :position, :tcc) }
end
