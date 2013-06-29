class Tcc < ActiveRecord::Base
  attr_accessible :leader, :moodle_user, :name, :tutor_group, :title, :state, :defense_date, :hubs_attributes,
                  :bibliography_attributes, :presentation_attributes, :abstract_attributes,
                  :final_considerations_attributes, :tcc_definition

  validates_uniqueness_of :moodle_user
  validates_inclusion_of :grade, in: 0..1, allow_nil: true

  has_many :hubs
  has_one :bibliography
  has_one :presentation
  has_one :abstract
  has_one :final_considerations

  belongs_to :tcc_definition

  has_many :references, :dependent => :destroy
  has_many :general_refs, :through => :references, :source => :element, :source_type => 'GeneralRef'
  has_many :book_refs, :through => :references, :source => :element, :source_type => 'BookRef'
  has_many :book_cap_refs, :through => :references, :source => :element, :source_type => 'BookCapRef'
  has_many :article_refs, :through => :references, :source => :element, :source_type => 'ArticleRef'
  has_many :internet_refs, :through => :references, :source => :element, :source_type => 'InternetRef'
  has_many :legislative_refs, :through => :references, :source => :element, :source_type => 'LegislativeRef'


  accepts_nested_attributes_for :hubs, :bibliography, :presentation, :abstract, :final_considerations

  include AASM
  aasm_column :state

  aasm do
    state :admin_evaluating, :initial => true
    state :teacher_evaluating

    event :admin_evaluate_ok do
      transitions :from => :admin_evaluating, :to => :teacher_evaluating
    end
  end

  def tcc_definition=(value)
    super(value)
    create_hubs
  end

  def fetch_all_hubs
    #TCC_CONFIG['hubs'].each_with_index.map { |item, index| hubs.find_or_initialize_by_category(index+1) }
    self.hubs.order(:category)
  end

  def hub_definitions
    self.tcc_definition.hub_definitions.order(:order)
  end

  def self.hub_names
    #TODO: Lógica temporária para contemplar recurso existente
    TccDefinition.first.hub_definitions.each.map {|h| h.title }
  end

  private

  def create_hubs
    self.tcc_definition.hub_definitions.each do |hub_definition|
      hub = Hub.create(tcc: self, hub_definition: hub_definition, category: hub_definition.order)
    end
  end

end
