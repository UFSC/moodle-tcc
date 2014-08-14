require 'spec_helper'

describe Hub do
  let!(:hub) { Fabricate(:hub) }
  let(:hub_tcc) { Fabricate(:hub_tcc) }

  it { should respond_to(:category, :reflection, :reflection_title, :grade, :commentary) }

  with_versioning do
    it 'should versioning' do
      old_version = hub.versions.size
      hub.update_attribute(:reflection, 'new content')
      hub.versions.size.should == (old_version + 1)
    end
  end

  describe 'reflection' do
    it 'should allow empty reflection if hub is new or draft' do
      hub.reflection = ''

      hub.new?.should be true
      hub.should be_valid

      hub.state = 'draft'
      hub.should be_valid
    end

    it 'should validate presence of reflection if hub is not new or draft' do
      hub.reflection = ''

      hub.state = 'sent_to_admin_for_revision'
      hub.should_not be_valid

      hub.state = 'sent_to_admin_for_evaluation'
      hub.should_not be_valid

      hub.state = 'admin_evaluation_ok'
      hub.should_not be_valid

      hub.state = 'terminated'
      hub.should_not be_valid
    end
  end

  describe 'grade_date' do
    it 'should be nil without grade' do
      hub.grade = nil
      hub.state = 'admin_evaluation_ok'
      hub.save
      hub.grade_date.should be_nil
    end

    it 'should be nil without admin_evaluation_ok' do
      hub.grade = 10
      hub.state = 'draft'
      hub.save
      hub.grade_date.should be_nil
    end

    it 'should be equal update_at with admin_evaluation_ok and grade' do
      hub.grade = 10
      hub.state = 'admin_evaluation_ok'
      hub.save
      hub.grade_date.should == hub.updated_at
    end

    it 'should not be equal update_at without admin_evaluation_ok' do
      hub.grade = 10
      hub.state = 'draft'
      hub.save
      hub.grade_date.should_not == hub.updated_at
    end
  end

  describe '#new_states_collection' do

    it 'should return a valid collection for HubPortfolio' do
      hub.class.new_states_collection.should_not be_empty
    end

    it 'should return a valid collection for HubTcc' do
      hub_tcc.class.new_states_collection.should_not be_empty
    end
  end

  describe '#clear_commentary!' do
    it 'should empty hub commentary' do
      hub.commentary = 'blablabla'
      hub.clear_commentary!
      hub.commentary.should be_empty
    end

    it 'should be invoked on transition to sent_to_admin_for_revision' do
      hub.commentary = 'blablabla'
      hub.save!
      hub.send_to_admin_for_revision
      hub.save!
      hub.commentary.should be_empty
    end

    it 'should be invoked on transition to sent_to_admin_for_evaluation' do
      hub.commentary = 'blablabla'
      hub.save!
      hub.send_to_admin_for_evaluation
      hub.save!
      hub.commentary.should be_empty
    end
  end
end
