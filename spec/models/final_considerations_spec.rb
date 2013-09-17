require 'spec_helper'

describe FinalConsiderations do
  let!(:final_considerations) { Fabricate(:final_considerations) }

  it { respond_to :commentary, :content, :state }

  it 'should versioning' do
    old_version = final_considerations.versions.size
    final_considerations.update_attribute(:content, 'new content')
    final_considerations.versions.size.should == (old_version + 1)
  end

  describe 'content' do
    it 'should allow empty reflection if final_considerations is new' do
      final_considerations.content = ''
      final_considerations.new?.should be_true
      final_considerations.should be_valid
    end

    it 'should validate presence of reflection if final_considerations is not new' do
      final_considerations.content = ''
      final_considerations.state = 'draft'
      final_considerations.draft?.should be_true
      final_considerations.should_not be_valid
    end
  end
end
