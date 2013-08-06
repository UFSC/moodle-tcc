class ChangeArticleRefsPublicationDate < ActiveRecord::Migration
  def up
    add_column :article_refs, :year, :integer, :after => :publication_date

    ArticleRef.reset_column_information

    article_refs = ArticleRef.all
    article_refs.each do |a|
      unless a.publication_date.nil?
        a.year = a.publication_date.year
        a.save
      end
    end

    remove_column :article_refs, :publication_date
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
