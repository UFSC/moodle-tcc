class ChangeArticleRefsPublicationDate < ActiveRecord::Migration
  def up
    add_column :article_refs, :year, :integer

    ArticleRef.reset_column_information

    article_refs = ArticleRef.all
    article_refs.each do |a|
      a.year = a.publication_date.year
      a.save
    end

    remove_column :article_refs, :publication_date
  end

  def down
    # Nada
  end
end
