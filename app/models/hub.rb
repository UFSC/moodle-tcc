class Hub < ActiveRecord::Base
  extend Enumerize

  belongs_to :tcc, :inverse_of => :hubs
  belongs_to :hub_definition, :inverse_of => :hubs
  has_many :diaries, :inverse_of => :hub
  accepts_nested_attributes_for :diaries

  include TccStateMachine

  # Estados para combo
  enumerize :new_state, in: Hub.aasm_states

  # Mass-Assignment
  attr_accessible :new_state, :category, :position, :reflection, :commentary, :grade, :diaries_attributes, :hub_definition, :tcc

  validates :grade, :numericality => {greater_than_or_equal_to: 0, less_than_or_equal_to: 100}, if: :admin_evaluation_ok?

  # TODO: renomear campo category no banco e remover esse workaround
  alias_attribute :category, :position

  def comparable_versions
    versions.where(:state => %w(sent_to_admin_for_evaluation, sent_to_admin_for_revision))
  end

  def fetch_diaries(user_id)
    Moodle.fetch_hub_diaries(self, user_id)
  end

  # Verifica se possui todos os diário associados a este eixo com algum tipo de conteúdo
  def filled_diaries?
    diaries.each do |d|
      return false if d.content.blank?
    end

    true
  end

  def hub_definition=(value)
    super(value)
    create_or_update_diaries
  end

  def empty?
    self.reflection.blank?
  end

  def grade_date
    if self.grade
      if self.admin_evaluation_ok?
        self.updated_at
      else
        self.versions.where(state: 'admin_evaluation_ok').order(:created_at).last.reify.updated_at
      end
    end
  end

  private

  def create_or_update_diaries
    hub_definition.diary_definitions.each do |diary_definition|
      if self.diaries.empty?
        self.diaries.build(hub: self, diary_definition: diary_definition, position: diary_definition.position)
      else
        diary = self.diaries.find_or_initialize_by_position diary_definition.position
        diary.diary_definition = diary_definition
        diary.save!
      end

    end
  end

end
