class Bibliography < ActiveRecord::Base

  belongs_to :tcc
  attr_accessible :content, :direct_quote, :indirect_quote

  #validate :not_repeat_references_for_tcc, :on => :create

  private

  def not_repeat_references_for_tcc
     #todo a ser definido ainda
  end

end

