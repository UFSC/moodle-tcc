require 'spec_helper'

describe GeneralRef do
  let(:general_ref) { Fabricate(:general_ref) }

  it { should respond_to(:direct_citation, :indirect_citation, :reference_text) }

  it { should have_one(:reference) }
  it { should have_one(:tcc).through(:reference) }

  it { should validate_presence_of(:direct_citation) }
  it { should validate_presence_of(:indirect_citation) }
  it { should validate_presence_of(:reference_text) }

end