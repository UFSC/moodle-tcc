require 'spec_helper'

describe Bibliography do
  let(:bibliography) { Fabricate(:bibliography) }

  it { should respond_to(:content, :direct_quote, :indirect_quote) }

  context 'validations' do

    describe 'id_referrence' do
      it 'should not be repeated occurrences' do
         pending
      end
    end

  end

end
