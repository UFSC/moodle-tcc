require 'spec_helper'

describe Presentation do
  let!(:presentation) { Fabricate(:presentation) }

  it { respond_to :commentary, :content, :state }
end