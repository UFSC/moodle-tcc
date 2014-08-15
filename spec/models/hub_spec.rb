require 'spec_helper'

describe Hub do
  let!(:hub) { Fabricate(:hub) }
  let(:hub_tcc) { Fabricate(:hub_tcc) }

  it { should respond_to(:category, :reflection, :reflection_title, :grade, :commentary) }

  with_versioning do
    it 'should versioning' do
      old_version = hub.versions.size
      hub.update_attribute(:reflection, 'new content')
      expect(hub.versions.size).to eq(old_version + 1)
    end
  end

  describe 'reflection' do
    it 'should allow empty reflection if hub is new or draft' do
      hub.reflection = ''

      expect(hub.new?).to be true
      expect(hub).to be_valid

      hub.state = 'draft'
      expect(hub).to be_valid
    end

    it 'should validate presence of reflection if hub is not new or draft' do
      hub.reflection = ''

      hub.state = 'sent_to_admin_for_revision'
      expect(hub).not_to be_valid

      hub.state = 'sent_to_admin_for_evaluation'
      expect(hub).not_to be_valid

      hub.state = 'admin_evaluation_ok'
      expect(hub).not_to be_valid

      hub.state = 'terminated'
      expect(hub).not_to be_valid
    end
  end

  describe 'grade_date' do
    it 'should be nil without grade' do
      hub.grade = nil
      hub.state = 'admin_evaluation_ok'
      hub.save
      expect(hub.grade_date).to be_nil
    end

    it 'should be nil without admin_evaluation_ok' do
      hub.grade = 10
      hub.state = 'draft'
      hub.save
      expect(hub.grade_date).to be_nil
    end

    it 'should be equal update_at with admin_evaluation_ok and grade' do
      hub.grade = 10
      hub.state = 'admin_evaluation_ok'
      hub.save
      expect(hub.grade_date).to eq(hub.updated_at)
    end

    it 'should not be equal update_at without admin_evaluation_ok' do
      hub.grade = 10
      hub.state = 'draft'
      hub.save
      expect(hub.grade_date).not_to eq(hub.updated_at)
    end
  end

  describe '#new_states_collection' do

    it 'should return a valid collection for HubPortfolio' do
      expect(hub.class.new_states_collection).not_to be_empty
    end

    it 'should return a valid collection for HubTcc' do
      expect(hub_tcc.class.new_states_collection).not_to be_empty
    end
  end

  describe '#clear_commentary!' do
    it 'should empty hub commentary' do
      hub.commentary = 'blablabla'
      hub.clear_commentary!
      expect(hub.commentary).to be_empty
    end

    it 'should be invoked on transition to sent_to_admin_for_revision' do
      hub.commentary = 'blablabla'
      hub.save!
      hub.send_to_admin_for_revision
      hub.save!
      expect(hub.commentary).to be_empty
    end

    it 'should be invoked on transition to sent_to_admin_for_evaluation' do
      hub.commentary = 'blablabla'
      hub.save!
      hub.send_to_admin_for_evaluation
      hub.save!
      expect(hub.commentary).to be_empty
    end
  end
end
