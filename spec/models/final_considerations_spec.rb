require 'spec_helper'

describe FinalConsiderations do
  let!(:final_considerations) { Fabricate(:final_considerations) }

  it { respond_to :commentary, :content, :state }

  with_versioning do
    it 'should versioning' do
      old_version = final_considerations.versions.size
      final_considerations.update_attribute(:content, 'new content')
      expect(final_considerations.versions.size).to eq(old_version + 1)
    end
  end

  describe 'content' do
    it 'should allow empty reflection if final_considerations is new' do
      final_considerations.content = ''
      expect(final_considerations.new?).to be true
      expect(final_considerations).to be_valid
    end

    it 'should validate presence of reflection if final_considerations is not new' do
      final_considerations.content = ''
      final_considerations.state = 'draft'
      expect(final_considerations.draft?).to be true
      expect(final_considerations).not_to be_valid
    end
  end

  context 'email notification' do
    let(:tcc) { Fabricate.build(:tcc_with_definitions) }
    let(:final_considerations) { Fabricate.build(:final_considerations) }

    it 'should send email to orientador when state changed from draft to revision' do
      final_considerations.tcc = tcc
      final_considerations.state = 'draft'
      final_considerations.send_to_admin_for_revision

      expect(ActionMailer::Base.deliveries.last.to).to eq([tcc.email_orientador])
    end

    it 'should send email to orientador when state changed from draft to revision' do
      final_considerations.tcc = tcc
      final_considerations.state = 'sent_to_admin_for_revision'
      final_considerations.send_back_to_student

      expect(ActionMailer::Base.deliveries.last.to).to eq([tcc.email_estudante])
    end

    it 'should change states even if email is blank' do
      final_considerations.state = 'sent_to_admin_for_revision'
      final_considerations.tcc = tcc
      tcc.email_estudante = ''
      tcc.save

      final_considerations.send_back_to_student
      final_considerations.save
      expect(final_considerations.state).to eq('draft')
    end

    it 'should change states even if email is nil' do
      final_considerations.state = 'sent_to_admin_for_revision'
      final_considerations.tcc = tcc
      tcc.email_estudante = nil
      tcc.save

      final_considerations.send_back_to_student
      final_considerations.save
      expect(final_considerations.state).to eq('draft')
    end

  end
end
