class AddTypeToHub < ActiveRecord::Migration
  def change
    add_column :hubs, :type, :string
    Hub.all.each do |hub|
      hub.update_column(:type, 'HubPortfolio')
    end
  end
end
