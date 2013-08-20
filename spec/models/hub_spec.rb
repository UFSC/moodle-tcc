require 'spec_helper'

describe Hub do
  let!(:hub) { Fabricate(:hub) }

  it { should respond_to(:category, :reflection, :grade, :commentary) }

  it 'should versioning' do
    old_version = hub.versions.size
    hub.update_attribute(:reflection, 'new content')
    hub.versions.size.should == ( old_version + 1 )
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
end
