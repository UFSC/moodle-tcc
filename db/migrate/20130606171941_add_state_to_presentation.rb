class AddStateToPresentation < ActiveRecord::Migration
  def change
    add_column :presentations, :state, :string
  end
end
