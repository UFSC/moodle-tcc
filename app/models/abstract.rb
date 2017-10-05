class Abstract < ActiveRecord::Base
  include Shared::DocumentState

  belongs_to :tcc, touch: true
  has_one :comment, :as => :chapter_commentable, :dependent => :destroy

  attr_accessible :content, :keywords, :comment

  before_validation :clean_blank_lines

  def empty?
    self.content.blank? && self.keywords.blank?
  end

  def citations
    doc = Nokogiri::HTML(self.content)
    block = doc.xpath("//citacao")
    chld_name = block.map { |node|
      [node['reference_id']] if node.key?('reference_id') }.compact
    chld_name.uniq
  end

  def count_citation
    self.citations.count
  end

  def has_citation?
    return (self.count_citation > 0)
  end

  def pending_versioning_count
    doc = Nokogiri::HTML(self.content)
    blockIns = doc.xpath("//ins").count
    blockDel = doc.xpath("//del").count
    blockIns+blockDel
  end

  def has_pending_versioning?
    return (self.pending_versioning_count > 0)
  end

  def clean_blank_lines
    new_content = TccContent::removeBlankLinesFromContent( self.content_was, self.content)
    self.content = new_content
    true
  end
end