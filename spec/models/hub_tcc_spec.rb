require 'spec_helper'

describe HubTcc do
  let(:hub) { Fabricate.build(:hub_tcc) }
  let(:tcc) { Fabricate.build(:tcc_with_definitions) }

  it 'should versioning' do
    old_version = hub.versions.size
    hub.update_attribute(:reflection, 'new content')
    hub.versions.size.should == (old_version + 1)
  end

  describe 'reflection' do
    it 'should allow empty reflection if hub is new or draft' do
      hub.reflection = ''

      hub.new?.should be_true
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

  context 'states changes' do
    it "should allow change to 'avaliado' even without grade as HubTcc doesn't have grades" do
      hub.grade = nil
      hub.state='sent_to_admin_for_evaluation'
      hub.may_admin_evaluate_ok?.should be_true
    end
  end

  context 'email notification' do
    before(:each) do
      hub.tcc = tcc
    end

    it 'should send email to orientador when state changed from draft to revision' do
      hub.state = 'draft'

      hub.send_to_admin_for_revision

      ActionMailer::Base.deliveries.last.to.should == [tcc.email_orientador]
    end

    it 'should send email to orientador when state changed from draft to revision' do
      hub.state = 'sent_to_admin_for_revision'

      hub.send_back_to_student

      ActionMailer::Base.deliveries.last.to.should == [tcc.email_estudante]
    end

    it 'should change states even if email is blank' do
      hub.state = 'sent_to_admin_for_revision'
      tcc.email_estudante = ''
      tcc.save!

      hub.send_back_to_student
      hub.save!
      hub.state.should == 'draft'
    end

    it 'should change states even if email is nil' do
      hub.state = 'sent_to_admin_for_revision'
      tcc.email_estudante = nil
      tcc.save!

      hub.send_back_to_student
      hub.save!
      hub.state.should == 'draft'
    end

  end

  describe '#clear_commentary!' do
    before(:each) do
      hub.tcc = tcc
    end

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