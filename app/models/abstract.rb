class Abstract < ActiveRecord::Base
  belongs_to :tcc
  attr_accessible :commentary, :content_en, :content_pt, :key_words_en, :key_words_pt
end
