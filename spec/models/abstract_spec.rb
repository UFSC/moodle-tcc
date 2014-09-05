require 'spec_helper'

describe Abstract do
  let!(:abstract) { Fabricate(:abstract) }

  it { respond_to :commentary, :content, :keywords }
end