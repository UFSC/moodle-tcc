class ChapterDefinition < ActiveRecord::Base
  belongs_to :tcc_definition, :inverse_of => :chapter_definitions, :touch => true
  has_many :chapters, :inverse_of => :chapter_definitions

  validates :position, presence: true
  validates :tcc_definition, presence: true
  validates :title, presence: true

  attr_accessible :position, :title, :tcc_definition, :tcc_definition_id, :coursemodule_id, :is_numbered_title, :verify_references

  default_scope -> { order(:position) }

  after_create :touch_tcc
  after_update :touch_tcc
  before_destroy :touch_tcc

  def remote_text?
    !coursemodule_id.nil?
  end

  private

  def touch_tcc
    # atualiza os tccs apenas se os campos abaixo forem alterados
    if (!title_was.eql?(title) ||
        !position_was.eql?(position) ||
        !is_numbered_title_was.eql?(is_numbered_title)
    )
      Tcc.where(tcc_definition_id: tcc_definition_id).update_all(:updated_at => DateTime.now)
    end
  end

end