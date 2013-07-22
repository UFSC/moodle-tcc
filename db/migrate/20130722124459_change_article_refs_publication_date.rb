class ChangeArticleRefsPublicationDate < ActiveRecord::Migration
  def up
    change_table :article_refs do |t|
      t.change :publication_date, :integer
      t.rename :publication_date, :year
    end
  end

  def down
    # Nada
  end
end
