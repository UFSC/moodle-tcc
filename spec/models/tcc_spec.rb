require 'spec_helper'

describe Tcc do
  let(:tcc) { Fabricate(:tcc) }

  it { should respond_to(:leader, :moodle_user, :name, :title, :grade, :defense_date) }

  it { should have_many(:references)}
  it { should have_many(:general_refs.through(:references))}

  it { should validate_uniqueness_of :moodle_user }

  describe 'grade' do
    it 'should be less than or equal to 1' do
      tcc.grade = 0.8
      tcc.should be_valid
    end

    it 'should not be higher than 1' do
      tcc.grade = 2
      tcc.should_not be_valid
    end
  end

  describe 'referencias' do

    it 'should return references' do
      r = Fabricate(:general_ref)
      tcc.references.create(:element => r)
      tcc.references
    end

    it 'should return a reference' do
      r = Fabricate(:general_ref)
      tcc.references.create(:element => r)
      tcc.references
    end
  end

end
