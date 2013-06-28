class CreateTccDefinitions < ActiveRecord::Migration
  def change
    create_table :tcc_definitions do |t|
      t.string :title

      t.timestamps
    end
  end
end
