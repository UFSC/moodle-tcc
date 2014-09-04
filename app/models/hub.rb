class Hub < ActiveRecord::Base

  belongs_to :tcc, :inverse_of => :hubs
  belongs_to :hub_definition, :inverse_of => :hubs
  has_many :diaries, :inverse_of => :hub
  accepts_nested_attributes_for :diaries

  # Mass-Assignment
  attr_accessible :type, :category, :position, :reflection, :reflection_title, :commentary, :diaries_attributes, :hub_definition, :tcc

  # TODO: renomear campo category no banco e remover esse workaround
  alias_attribute :category, :position

  # Hubs por tipo (polimórfico)
  scope :hub_portfolio, -> { where(:type => 'HubPortfolio') }
  scope :hub_tcc, -> { where(:type => 'HubTcc') }
  scope :hub_by_type, ->(type) { send("hub_#{type}") }
  scope :reflection_empty, -> { where(reflection: '') }

  # @deprecated funcionalidade será descontinuada na nova versão
  def fetch_diaries(user_id)
    MoodleAPI::MoodleHub.fetch_hub_diaries(self, user_id)
  end

  # @deprecated funcionalidade será descontinuada na nova versão
  def fetch_diaries_for_printing(user_id)
    MoodleAPI::MoodleHub.fetch_hub_diaries_for_printing(self, user_id)
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

  def clear_commentary!
    self.commentary = ''
  end

  private

  def create_or_update_diaries
    hub_definition.diary_definitions.each do |diary_definition|
      if self.diaries.empty?
        self.diaries.build(hub: self, diary_definition: diary_definition, position: diary_definition.position)
      else
        diary = self.diaries.find_or_initialize_by(position: diary_definition.position)
        diary.diary_definition = diary_definition
        diary.save!
      end

    end
  end

end
