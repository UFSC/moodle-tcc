require 'spec_helper'

describe Abstract do
  it { respond_to :commentary, :content_en, :content_pt, :key_words_en, :key_words_pt }
end
