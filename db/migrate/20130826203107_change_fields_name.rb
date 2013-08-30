class ChangeFieldsName < ActiveRecord::Migration
  def change
    rename_column :abstracts, :key_words_pt, :key_words
    rename_column :abstracts, :content_pt, :content
  end
end
