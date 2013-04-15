class Tcc < ActiveRecord::Base
  attr_accessible :final_considerations, :final_considerations_commentary, :leader, :moodle_user, :name, :presentation, :title, :year_defense,
                  :abstract, :abstract_key_words, :abstract_commentary, :presentation_commentary,
                  :english_abstract, :english_abstract_key_words, :english_abstract_commentary


  validates_uniqueness_of :moodle_user
  validates_inclusion_of :grade, in: 0..1, allow_nil: true

  has_many :hubs
  has_one :bibliography
end
