require 'spec_helper'

describe HubTcc do
  let(:hub) { Fabricate.build(:hub_tcc) }
  let(:tcc) { Fabricate.build(:tcc_with_definitions) }


  with_versioning do
    it 'should versioning' do
      old_version = hub.versions.size
      hub.update_attribute(:reflection, 'new content')
      hub.reload
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

  context 'states changes' do
    it "should allow change to 'avaliado' even without grade as HubTcc doesn't have grades" do
      hub.grade = nil
      hub.state='sent_to_admin_for_evaluation'
      expect(hub.may_admin_evaluate_ok?).to be true
    end
  end

  context 'email notification' do
    before(:each) do
      hub.tcc = tcc
    end

    it 'should send email to orientador when state changed from draft to revision' do
      hub.state = 'draft'

      hub.send_to_admin_for_revision

      expect(ActionMailer::Base.deliveries.last.to).to eq([tcc.email_orientador])
    end

    it 'should send email to orientador when state changed from draft to revision' do
      hub.state = 'sent_to_admin_for_revision'

      hub.send_back_to_student

      expect(ActionMailer::Base.deliveries.last.to).to eq([tcc.email_estudante])
    end

    it 'should change states even if email is blank' do
      hub.state = 'sent_to_admin_for_revision'
      tcc.email_estudante = ''
      tcc.save

      hub.send_back_to_student
      hub.save
      expect(hub.state).to eq('draft')
    end

    it 'should change states even if email is nil' do
      hub.state = 'sent_to_admin_for_revision'
      tcc.email_estudante = nil
      tcc.save

      hub.send_back_to_student
      hub.save
      expect(hub.state).to eq('draft')
    end

  end

  describe '#clear_commentary!' do
    before(:each) do
      hub.tcc = tcc
    end

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