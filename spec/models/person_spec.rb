require 'spec_helper'

describe Person do
  let(:person) { Fabricate.build(:person) }

  it { should respond_to :name, :email, :moodle_username, :moodle_id }
  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :moodle_username }
  it { should validate_presence_of :moodle_id }
  it { should validate_numericality_of :moodle_id }
  it { should validate_uniqueness_of :moodle_username }
end