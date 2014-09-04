require 'spec_helper'

describe FinalConsiderations do
  let!(:final_considerations) { Fabricate(:final_considerations) }

  it { respond_to :commentary, :content, :state }
end
