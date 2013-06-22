class AddTutorGroupToTcc < ActiveRecord::Migration
  def change
    add_column :tccs, :tutor_group, :integer
  end
end
