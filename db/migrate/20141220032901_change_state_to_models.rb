class ChangeStateToModels < ActiveRecord::Migration
  def change
    change_column_default(:abstracts, :state, 'empty')
    change_column_default(:chapters, :state, 'empty')
  end
end
