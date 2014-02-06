class CreateCompoundNames < ActiveRecord::Migration
  def change
    create_table :compound_names do |t|
      t.string :name

      t.timestamps
    end
  end
end
