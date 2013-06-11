class RenameHubStateColumn < ActiveRecord::Migration
  def self.up
    rename_column :hubs, :tcc_state, :portfolio_state
  end

  def self.down

  end
end
