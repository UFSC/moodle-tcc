class Reference < ActiveRecord::Base
  validates_presence_of :tcc_id, :element_id

  attr_accessible :element;

  belongs_to :tcc
  belongs_to :element, :polymorphic => true

end
