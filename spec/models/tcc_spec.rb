require 'spec_helper'

describe Tcc do
  let(:tcc) { Fabricate(:tcc) }

  it { should respond_to( :final_considerations, :final_considerations_commentary, :leader, :moodle_user, :name,:presentation,:title,
                          :grade, :year_defense, :abstract, :abstract_key_words, :abstract_commentary,
                          :english_abstract, :english_abstract_key_words, :english_abstract_commentary, :presentation_commentary ) }

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
end
