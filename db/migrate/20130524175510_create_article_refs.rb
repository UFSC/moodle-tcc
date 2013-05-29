class CreateArticleRefs < ActiveRecord::Migration
  def change
    create_table :article_refs do |t|
      t.string :first_author
      t.string :second_author
      t.string :third_author
      t.boolean :et_all
      t.string :article_title
      t.string :article_subtitle
      t.string :journal_name
      t.string :local
      t.integer :volume_number
      t.integer :number_or_fascicle
      t.date :publication_date
      t.integer :initial_page
      t.integer :end_page
    end
  end
end
