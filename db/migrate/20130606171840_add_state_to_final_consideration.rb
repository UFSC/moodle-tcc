class AddStateToFinalConsideration < ActiveRecord::Migration
  def change
    add_column :final_considerations  , :state, :string
  end
end
