require 'spec_helper'

describe Presentation do
  let!(:presentation) { Fabricate(:presentation) }

  it { respond_to :commentary, :content, :state }

  it 'should versioning' do
    old_version = presentation.versions.size
    presentation.update_attribute(:content, 'new content')
    presentation.versions.size.should == (old_version + 1)
  end

  describe 'content' do
    it 'should allow empty reflection if presentation is new' do
      presentation.content = ''
      presentation.new?.should be_true
      presentation.should be_valid
    end

    it 'should validate presence of reflection if presentation is not new' do
      presentation.content = ''
      presentation.state = 'draft'
      presentation.draft?.should be_true
      presentation.should_not be_valid
    end
  end
end
