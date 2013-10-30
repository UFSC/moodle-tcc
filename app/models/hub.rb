# encoding: utf-8
class Hub < ActiveRecord::Base
  extend Enumerize

  belongs_to :tcc, :inverse_of => :hubs
  belongs_to :hub_definition, :inverse_of => :hubs
  has_many :diaries, :inverse_of => :hub
  accepts_nested_attributes_for :diaries

  # Mass-Assignment
  attr_accessible :type, :new_state, :category, :position, :reflection, :reflection_title, :commentary, :grade, :diaries_attributes, :hub_definition, :tcc

  # TODO: renomear campo category no banco e remover esse workaround
  alias_attribute :category, :position

  # Hubs por tipo (polimórfico)
  scope :hub_portfolio, where(:type => 'HubPortfolio')
  scope :hub_tcc, where(:type => 'HubTcc')
  scope :hub_by_type, ->(type) { send("hub_#{type}") }

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
    if self.grade && self.admin_evaluation_ok?
      self.updated_at
    else
      last_version = self.versions.where(state: 'admin_evaluation_ok').order(:created_at).last
      unless last_version.nil?
        last_version.reify.updated_at
      end
    end
  end

  def self.new_states_collection
    new_state.options - [['Finalizado', 'terminated']] - [['Novo', 'new']]
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
