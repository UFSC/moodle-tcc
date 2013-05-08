class Tcc < ActiveRecord::Base
  attr_accessible :leader, :moodle_user, :name, :title, :defense_date, :hubs_attributes,
                  :bibliography_attributes, :presentation_attributes, :abstract_attributes, :final_considerations_attributes




  validates_uniqueness_of :moodle_user
  validates_inclusion_of :grade, in: 0..1, allow_nil: true

  has_many :hubs
  has_one :bibliography
  has_one :presentation
  has_one :abstract
  has_one :final_considerations

  has_many :references,  :dependent => :destroy
  has_many :general_refs, :through => :references, :source => :element, :source_type => 'GeneralRef'

  accepts_nested_attributes_for :hubs, :bibliography, :presentation, :abstract, :final_considerations

end
