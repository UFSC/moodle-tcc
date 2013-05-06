require 'spec_helper'

describe Tcc do
  let(:tcc) { Fabricate(:tcc) }

  it { should respond_to(:leader, :moodle_user, :name, :title, :grade, :defense_date) }

  it { should have_many(:references)}
  it { should have_many(:general_refs).through(:references)}

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
    before(:each) do
      @ref = Fabricate(:general_ref)
    end

    it 'should return references' do
      tcc.references.create(:element => @ref)
      tcc.references.count.should equal(1)
    end

    it 'should create valid element' do
      tcc.references.create(:element => @ref)
      tcc.references.first.hash.should equal(@ref.hash)

      novo = Fabricate(:general_ref)

      tcc.references.create(:element => novo)
      tcc.references.count.should equal(2)
      tcc.references.last.hash.should_not equal(@ref.hash)
      tcc.references.last.hash.should equal(novo.hash)
    end
  end

end
