require 'spec_helper'

describe Diary do
  let(:diary) { Fabricate(:diary) }

  it { should respond_to(:content, :title, :pos) }
end
