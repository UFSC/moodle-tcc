class Chapter < ActiveRecord::Base
  include Shared::DocumentState

  belongs_to :tcc, :inverse_of => :chapters, touch: true
  belongs_to :chapter_definition, :inverse_of => :chapters
  has_one :comment, :as => :chapter_commentable, class_name: 'Comment', :dependent => :destroy

  # Mass-Assignment
  attr_accessible :position, :content, :chapter_definition, :tcc, :comment

  before_validation :clean_blank_lines

  # Hubs por tipo (polimórfico)
  scope :reflection_empty, -> { where(content: '') }

  def empty?
    (self.content.nil? || self.content.empty?)
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