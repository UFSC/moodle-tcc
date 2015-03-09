class AddMinimumReferencesToTccDefinitions < ActiveRecord::Migration
  def change
    add_column :tcc_definitions, :minimum_references, :integer, :after => :moodle_instance_id
  end
end
