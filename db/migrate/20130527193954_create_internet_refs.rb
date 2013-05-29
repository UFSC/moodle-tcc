class CreateInternetRefs < ActiveRecord::Migration
  def change
    create_table :internet_refs do |t|
      t.string :author
      t.string :title
      t.string :subtitle
      t.string :url
      t.date :access_date
    end
  end
end
