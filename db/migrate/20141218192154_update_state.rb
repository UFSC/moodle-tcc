class UpdateState < ActiveRecord::Migration
  def change
    Abstract.where("state = 'draft' AND content IS NULL").update_all(state: :empty)
    Chapter.where("state = 'draft' AND content IS NULL").update_all(state: :empty)
  end
end
