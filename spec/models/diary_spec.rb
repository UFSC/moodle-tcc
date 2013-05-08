require 'spec_helper'

describe Diary do
  let(:diary) { Fabricate(:diary) }

  it { should respond_to(:content, :title, :pos) }

  it 'should versioning' do
    old_version = diary.version
    diary.update_attribute(:content, 'new content')
    diary.version.should == ( old_version + 1 )
  end
end
