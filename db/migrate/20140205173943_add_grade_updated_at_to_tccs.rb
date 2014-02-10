class AddGradeUpdatedAtToTccs < ActiveRecord::Migration
  def change
    add_column :tccs, :grade_updated_at, :datetime
  end
end
