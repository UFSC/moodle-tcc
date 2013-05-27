class InternetRef < ActiveRecord::Base

  validates_presence_of :access_date, :author, :title, :url

  attr_accessible :access_date, :author, :subtitle, :title, :url

  has_one :reference, :as => :element, :dependent => :destroy
  has_one :tcc, :through => :references
end
