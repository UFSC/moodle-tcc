class RenameChapterCommentToComment < ActiveRecord::Migration
  def change
    rename_table :chapter_comments, :comments
  end
end
