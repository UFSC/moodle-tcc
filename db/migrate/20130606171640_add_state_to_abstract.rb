class AddStateToAbstract < ActiveRecord::Migration
  def change
    add_column :abstracts, :state, :string
  end
end
