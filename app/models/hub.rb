class Hub < ActiveRecord::Base

  belongs_to :tcc, :inverse_of => :hubs
  belongs_to :hub_definition, :inverse_of => :hubs

  # Mass-Assignment
  attr_accessible :type, :position, :reflection, :reflection_title, :hub_definition, :tcc

  # Hubs por tipo (polimórfico)
  scope :hub_portfolio, -> { where(:type => 'HubPortfolio') }
  scope :hub_tcc, -> { where(:type => 'HubTcc') }
  scope :hub_by_type, ->(type) { send("hub_#{type}") }
  scope :reflection_empty, -> { where(reflection: '') }

  def empty?
    self.reflection.blank?
  end

  def clear_commentary!
    self.commentary = ''
  end

end
