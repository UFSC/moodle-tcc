require 'spec_helper'

describe Tcc do
  let(:tcc) { Fabricate(:tcc) }

  it { should respond_to( :final_considerations, :leader, :moodle_user, :name, :presentation, :summary, :title ) }

  it { should validate_uniqueness_of :moodle_user }

  it 'should be valid' do
    puts tcc.inspect
    tcc.should be_valid
  end
end
