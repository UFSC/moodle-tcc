require 'spec_helper'

describe Abstract do
  it { respond_to :commentary, :content_pt, :key_words_pt }
end
