class ChapterComment < ActiveRecord::Base
  validates_presence_of :chapter_commentable_id

  attr_accessible :comment

  def empty?
    (self.comment.nil? || self.comment.empty?)
  end

end

