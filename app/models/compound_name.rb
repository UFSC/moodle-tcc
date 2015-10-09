class CompoundName < ActiveRecord::Base
  attr_accessible :name, :type_name

  include Shared::Search
  default_scope -> { order(:name) }
  scoped_search :on => [:name]

  validates_presence_of :name, :type_name

  after_commit :touch_tcc, on: [:create, :update]
  before_destroy :touch_tcc


  private

  def touch_tcc
    Tcc.update_all(:updated_at => DateTime.now)
  end

end
