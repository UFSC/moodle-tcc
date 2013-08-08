class AddSubtypeToArticleRef < ActiveRecord::Migration
  def change
    add_column :article_ref, :subtype, :string
  end
end
