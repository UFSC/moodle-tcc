class AddStateToModels < ActiveRecord::Migration
  def change
    add_column :abstracts, :state, :string, default: :draft
    add_column :abstracts, :state_date, :date #, default: Date.today
    add_column :chapters, :state, :string, default: :draft
    add_column :chapters, :state_date, :date #, default: Date.today
  end

end
