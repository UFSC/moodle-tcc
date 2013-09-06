class AddOrientadorToTcc < ActiveRecord::Migration
  def change
    add_column :tccs, :orientador, :integer
  end
end
