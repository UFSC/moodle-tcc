class ChapterDefinition < ActiveRecord::Base
  belongs_to :tcc_definition, :inverse_of => :chapter_definitions, :touch => true
  has_many :chapters, :inverse_of => :chapter_definitions

  validates :position, presence: true
  validates :tcc_definition, presence: true
  validates :title, presence: true

  attr_accessible :position, :title, :tcc_definition, :tcc_definition_id

  default_scope -> { order(:position) }

  after_commit :touch_tcc, on: [:create, :update]
  before_destroy :touch_tcc

  def remote_text?
    !coursemodule_id.nil?
  end

  private

  def touch_tcc
    Tcc.update_all(:updated_at => DateTime.now)
  end

end