class AddVerifyReferencesToChapterDefinitions < ActiveRecord::Migration
  def change
    add_column :chapter_definitions, :verify_references, :boolean, default: true, :after => :is_numbered_title
  end
end
