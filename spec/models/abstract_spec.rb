require 'spec_helper'

describe Abstract do
  let!(:abstract) { Fabricate(:abstract) }

  it { respond_to :commentary, :content, :key_words, :state }

  with_versioning do
    it 'should versioning' do
      old_version = abstract.versions.size
      abstract.update_attribute(:content, 'new content')
      expect(abstract.versions.size).to eq(old_version + 1)
    end
  end

  describe 'content' do
    it 'should allow empty reflection if abstract is new' do
      abstract.content = ''
      expect(abstract.new?).to be true
      expect(abstract).to be_valid
    end

    it 'should validate presence of reflection if abstract is not new' do
      abstract.content = ''
      abstract.state = 'draft'
      expect(abstract.draft?).to be true
      expect(abstract).not_to be_valid
    end
  end

  context 'email notification' do
    let(:tcc) { Fabricate.build(:tcc_with_definitions) }
    let(:abstract) { Fabricate.build(:abstract) }

    it 'should send email to orientador when state changed from draft to revision' do
      abstract.tcc = tcc
      abstract.state = 'draft'
      abstract.send_to_admin_for_revision

      expect(ActionMailer::Base.deliveries.last.to).to eq([tcc.email_orientador])
    end

    it 'should send email to orientador when state changed from draft to revision' do
      abstract.tcc = tcc
      abstract.state = 'sent_to_admin_for_revision'
      abstract.send_back_to_student

      expect(ActionMailer::Base.deliveries.last.to).to eq([tcc.email_estudante])
    end

    it 'should change states even if email is blank' do
      abstract.state = 'sent_to_admin_for_revision'
      abstract.tcc = tcc
      tcc.email_estudante = ''
      tcc.save

      abstract.send_back_to_student
      abstract.save
      expect(abstract.state).to eq('draft')
    end

    it 'should change states even if email is nil' do
      abstract.state = 'sent_to_admin_for_revision'
      abstract.tcc = tcc
      tcc.email_estudante = nil
      tcc.save

      abstract.send_back_to_student
      abstract.save
      expect(abstract.state).to eq('draft')
    end
  end
end
