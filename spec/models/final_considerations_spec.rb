require 'spec_helper'

describe FinalConsiderations do
  let!(:final_considerations) { Fabricate(:final_considerations) }

  it { respond_to :commentary, :content }

  it 'should versioning' do
    old_version = final_considerations.version
    final_considerations.update_attribute(:content, 'new content')
    final_considerations.version.should == ( old_version + 1 )
  end
end
