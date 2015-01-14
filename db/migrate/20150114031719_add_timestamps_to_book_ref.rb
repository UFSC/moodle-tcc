class AddTimestampsToBookRef < ActiveRecord::Migration
  def up
    change_table :book_cap_refs do |t|
      t.timestamps
    end

    change_table :book_refs do |t|
      t.timestamps
    end

    change_table :internet_refs do |t|
      t.timestamps
    end

    change_table :legislative_refs do |t|
      t.timestamps
    end

    change_table :thesis_refs do |t|
      t.timestamps
    end
  end
  def down
    remove_column :book_cap_refs, :created_at
    remove_column :book_cap_refs, :updated_at
    remove_column :book_refs, :created_at
    remove_column :book_refs, :updated_at
    remove_column :internet_refs, :created_at
    remove_column :internet_refs, :updated_at
    remove_column :legislative_refs, :created_at
    remove_column :legislative_refs, :updated_at
    remove_column :thesis_refs, :created_at
    remove_column :thesis_refs, :updated_at
  end
end
