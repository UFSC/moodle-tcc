class Diary < ActiveRecord::Base
  belongs_to :hub
  belongs_to :diary_definition

  attr_accessible :content, :pos, :position, :diary_definition, :hub

  # TODO: renomear campo pos no banco e remover esse workaround
  alias_attribute :pos, :position

  def empty?
    self.content.blank?
  end

end