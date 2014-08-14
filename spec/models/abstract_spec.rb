require 'spec_helper'

describe Abstract do
  let!(:abstract) { Fabricate(:abstract) }

  it { respond_to :commentary, :content, :key_words, :state }

  with_versioning do
    it 'should versioning' do
      old_version = abstract.versions.size
      abstract.update_attribute(:content, 'new content')
      abstract.versions.size.should == (old_version + 1)
    end
  end

  describe 'content' do
    it 'should allow empty reflection if abstract is new' do
      abstract.content = ''
      abstract.new?.should be true
      abstract.should be_valid
    end

    it 'should validate presence of reflection if abstract is not new' do
      abstract.content = ''
      abstract.state = 'draft'
      abstract.draft?.should be true
      abstract.should_not be_valid
    end
  end

  context 'email notification' do
    let(:tcc) { Fabricate.build(:tcc_with_definitions) }
    let(:abstract) { Fabricate.build(:abstract) }

    it 'should send email to orientador when state changed from draft to revision' do
      abstract.tcc = tcc
      abstract.state = 'draft'
      abstract.send_to_admin_for_revision

      ActionMailer::Base.deliveries.last.to.should == [tcc.email_orientador]
    end

    it 'should send email to orientador when state changed from draft to revision' do
      abstract.tcc = tcc
      abstract.state = 'sent_to_admin_for_revision'
      abstract.send_back_to_student

      ActionMailer::Base.deliveries.last.to.should == [tcc.email_estudante]
    end

    it 'should change states even if email is blank' do
      abstract.state = 'sent_to_admin_for_revision'
      abstract.tcc = tcc
      tcc.email_estudante = ''
      tcc.save

      abstract.send_back_to_student
      abstract.save
      abstract.state.should == 'draft'
    end

    it 'should change states even if email is nil' do
      abstract.state = 'sent_to_admin_for_revision'
      abstract.tcc = tcc
      tcc.email_estudante = nil
      tcc.save

      abstract.send_back_to_student
      abstract.save
      abstract.state.should == 'draft'
    end
  end
end
