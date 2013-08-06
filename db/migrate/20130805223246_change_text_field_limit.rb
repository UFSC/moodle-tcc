class ChangeTextFieldLimit < ActiveRecord::Migration
  def up
    change_column :abstracts, :content_pt, :text, limit: 16.megabytes-1 # MySQL: MEDIUMTEXT
    change_column :diaries, :content, :text, limit: 16.megabytes-1 # MySQL: MEDIUMTEXT
    change_column :final_considerations, :content, :text, limit: 16.megabytes-1 # MySQL: MEDIUMTEXT
    change_column :hubs, :reflection, :text, limit: 16.megabytes-1 # MySQL: MEDIUMTEXT
    change_column :presentations, :content, :text, limit: 16.megabytes-1 # MySQL: MEDIUMTEXT
    change_column :versions, :object, :text, limit: 4.gigabytes-1 # MySQL: LONGTEXT
  end

  def down
    change_column :abstracts, :content_pt, :text, limit: nil
    change_column :diaries, :content, :text, limit: nil
    change_column :final_considerations, :content, :text, limit: nil
    change_column :hubs, :reflection, :text, limit: nil
    change_column :presentations, :content, :text, limit: nil
    change_column :versions, :object, :text, limit: nil

  end
end
