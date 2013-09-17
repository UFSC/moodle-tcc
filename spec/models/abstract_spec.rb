require 'spec_helper'

describe Abstract do
  let!(:abstract) { Fabricate(:abstract) }

  it { respond_to :commentary, :content, :key_words, :state }

  it 'should versioning' do
    old_version = abstract.versions.size
    abstract.update_attribute(:content, 'new content')
    abstract.versions.size.should == (old_version + 1)
  end

  describe 'content' do
    it 'should allow empty reflection if abstract is new' do
      abstract.content = ''
      abstract.new?.should be_true
      abstract.should be_valid
    end

    it 'should validate presence of reflection if abstract is not new' do
      abstract.content = ''
      abstract.state = 'draft'
      abstract.draft?.should be_true
      abstract.should_not be_valid
    end
  end
end
