class InternetRef < ActiveRecord::Base
  has_one :reference, :as => :element, :dependent => :destroy
  has_one :tcc, :through => :references

  VALID_URL_EXPRESSION = /^(http|https|ftp|ftps):\/\/(([a-z0-9]+\:)?[a-z0-9]+\@)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix

  validates_presence_of :access_date, :author, :title, :url

  attr_accessible :access_date, :author, :subtitle, :title, :url

  validates_format_of :url, :with => VALID_URL_EXPRESSION
end
