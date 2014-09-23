class Tcc < ActiveRecord::Base
  attr_accessible :moodle_user, :student, :tutor, :orientador, :title, :tcc_definition, :defense_date,
                  :abstract_attributes, :chapters_attributes,
                  :final_considerations_attributes, :presentation_attributes

  has_many :chapters, :inverse_of => :tcc
  has_one :presentation, :inverse_of => :tcc
  has_one :abstract, :inverse_of => :tcc
  has_one :final_considerations, :inverse_of => :tcc

  belongs_to :tcc_definition, :inverse_of => :tccs

  # Referencias
  has_many :references, :dependent => :destroy
  has_many :general_refs, :through => :references, :source => :element, :source_type => 'GeneralRef'
  has_many :book_refs, :through => :references, :source => :element, :source_type => 'BookRef'
  has_many :book_cap_refs, :through => :references, :source => :element, :source_type => 'BookCapRef'
  has_many :article_refs, :through => :references, :source => :element, :source_type => 'ArticleRef'
  has_many :internet_refs, :through => :references, :source => :element, :source_type => 'InternetRef'
  has_many :legislative_refs, :through => :references, :source => :element, :source_type => 'LegislativeRef'
  has_many :thesis_refs, :through => :references, :source => :element, :source_type => 'ThesisRef'

  # Pessoas / papeis envolvidos:
  belongs_to :student, class_name: 'Person'
  belongs_to :tutor, class_name: 'Person'
  belongs_to :orientador, class_name: 'Person'

  accepts_nested_attributes_for :chapters, :presentation, :abstract, :final_considerations

  include Shared::Search
  default_scope -> { joins(:student).order('people.name') }
  scoped_search :on => [:name]

  # Retorna o nome do estudante sem a matrícula ()
  def student_name
    self.name.gsub(/ \([0-9].*\)/, '')
  end

  def tcc_definition=(value)
    super(value)
    create_or_update_chapters
  end

  def chapter_definitions
    # FIXME: order já foi migrada para scope, incluir testes
    self.tcc_definition.chapter_definitions.order(:position)
  end

  # Método responsável por criar os models relacionados ao TCC
  def create_dependencies!
    self.build_abstract if self.abstract.nil?
  end

  private

  def create_or_update_chapters
    self.tcc_definition.chapter_definitions.each do |chapter_definition|

      if self.chapters.empty?
        self.chapters.build(tcc: self, chapter_definition: chapter_definition, position: chapter_definition.position)
      else
        chapter_tcc = self.chapters.find_or_initialize_by(position: chapter_definition.position)
        chapter_tcc.chapter_definition = chapter_definition
        chapter_tcc.save!
      end

    end
  end

end