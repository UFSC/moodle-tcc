class AddTccStateToHubs < ActiveRecord::Migration
  def change
    add_column :hubs, :tcc_state, :string
  end
end
