class CreateChapterComments < ActiveRecord::Migration
  def change
    create_table :chapter_comments do |t|
      t.text :comment, limit: 16.megabytes-1 # MySQL: MEDIUMTEXT
      t.references :chapter_commentable, polymorphic: true
      t.string :chapter_commentable_type

      t.timestamps
    end
    add_index :chapter_comments, :chapter_commentable_id
  end

end
