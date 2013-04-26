require 'spec_helper'

describe Diary do
  it { should respond_to(:content, :title) }
end
