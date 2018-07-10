class ChangeMoodleAssets < ActiveRecord::Migration
  def up
    change_column(:moodle_assets, :etag, :text)

  end
  def down
    # This might cause trouble if you have strings longer
    # than 255 characters.
    change_column(:moodle_assets, :etag, :string)
  end
end
