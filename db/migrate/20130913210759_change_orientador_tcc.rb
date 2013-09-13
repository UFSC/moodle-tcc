class ChangeOrientadorTcc < ActiveRecord::Migration
  def change
    change_column :tccs, :orientador, :string
  end
end
