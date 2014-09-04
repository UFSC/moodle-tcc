class Tcc < ActiveRecord::Base
  attr_accessible :grade, :orientador, :moodle_user, :tutor_group, :title, :state, :defense_date, :hubs_attributes,
                  :bibliography_attributes, :presentation_attributes, :abstract_attributes,
                  :final_considerations_attributes, :tcc_definition, :grade_updated_at

  validates_uniqueness_of :moodle_user
  validates :grade, :numericality => {greater_than_or_equal_to: 0, less_than_or_equal_to: 100}, allow_nil: true

  has_many :hubs, :inverse_of => :tcc
  has_many :hubs_portfolios, class_name: 'HubPortfolio'
  has_many :hubs_tccs, class_name: 'HubTcc'
  has_one :bibliography
  has_one :presentation
  has_one :abstract
  has_one :final_considerations

  belongs_to :tcc_definition, :inverse_of => :tccs

  has_many :references, :dependent => :destroy
  has_many :general_refs, :through => :references, :source => :element, :source_type => 'GeneralRef'
  has_many :book_refs, :through => :references, :source => :element, :source_type => 'BookRef'
  has_many :book_cap_refs, :through => :references, :source => :element, :source_type => 'BookCapRef'
  has_many :article_refs, :through => :references, :source => :element, :source_type => 'ArticleRef'
  has_many :internet_refs, :through => :references, :source => :element, :source_type => 'InternetRef'
  has_many :legislative_refs, :through => :references, :source => :element, :source_type => 'LegislativeRef'
  has_many :thesis_refs, :through => :references, :source => :element, :source_type => 'ThesisRef'

  belongs_to :student, class_name: 'Person'
  belongs_to :tutor, class_name: 'Person'
  belongs_to :orientador, class_name: 'Person'

  # Salvar a nota no moodle caso ela tenha mudado
  before_save :post_moodle_grade

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
  
  include Shared::Search
  default_scope -> { order(:name) }
  scoped_search :on => [:name]

  # Retorna o nome do estudante sem a matrícula ()
  def student_name
    self.name.gsub(/ \([0-9].*\)/, '')
  end

  # Metodo para realizar se todos as partes do TCC estão avaliadas e ok
  def is_ok?
    boolean_presentation = !presentation.nil? ? presentation.admin_evaluation_ok? : false
    boolean_abstract = !abstract.nil? ? abstract.admin_evaluation_ok? : false
    boolean_final_considerations = !final_considerations.nil? ? final_considerations.admin_evaluation_ok? : false

    boolean_presentation && boolean_abstract && boolean_final_considerations && is_hubs_tcc_ok?
  end

  # Verifica se os hubs estão todos avaliados
  def is_hubs_tcc_ok?
    hubs.hub_tcc.each do |hub|
      return false if !hub.admin_evaluation_ok?
    end
    true
  end

  def tcc_definition=(value)
    super(value)
    create_or_update_hubs
  end

  def fetch_all_hubs(type)
    if type == 'portfolio'
      self.hubs.hub_portfolio.order(:position)
    else
      self.hubs.hub_tcc.order(:position)
    end
  end

  def hub_definitions
    self.tcc_definition.hub_definitions.order(:position)
  end

  def self.hub_names
    # Lógica temporária para contemplar recurso existente
    # TODO: Encontrar uma relação entre o tipo de tcc_definition passado no LTI e filtrar somente itens daquele tipo.
    TccDefinition.first.hub_definitions.each.map { |h| h.title }
  end

  # Método responsável por criar os models relacionados ao TCC
  def create_dependencies!
    self.build_abstract if self.abstract.nil?
    self.build_final_considerations if self.final_considerations.nil?
    self.build_presentation if self.presentation.nil?
  end

  def post_moodle_grade
    if self.grade_changed? && self.tcc_definition && self.tcc_definition.course_id
      MoodleGrade.set_grade(self.moodle_user, self.tcc_definition.course_id, self.tcc_definition.name, self.grade);
    end
  end

  private

  def create_or_update_hubs
    self.tcc_definition.hub_definitions.each do |hub_definition|

      # Verificação da ramificação do usuário para os eixo que tiverem ramificações
      if hub_definition.moodle_shortname.nil? || MiddlewareUser::check_enrol(self.moodle_user, hub_definition.moodle_shortname)
        if self.hubs.empty?
          self.hubs.build(tcc: self, hub_definition: hub_definition, position: hub_definition.position, type: 'HubPortfolio')
          self.hubs.build(tcc: self, hub_definition: hub_definition, position: hub_definition.position, type: 'HubTcc')
        else
          hub_portfolio = self.hubs.hub_portfolio.find_or_initialize_by(position: hub_definition.position)
          hub_tcc = self.hubs.hub_tcc.find_or_initialize_by(position: hub_definition.position)
          hub_portfolio.hub_definition = hub_definition
          hub_tcc.hub_definition = hub_definition
          hub_portfolio.save!
          hub_tcc.save!
        end
      end

    end
  end

end