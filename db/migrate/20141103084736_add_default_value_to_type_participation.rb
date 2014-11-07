class AddDefaultValueToTypeParticipation < ActiveRecord::Migration
  def up
    change_column_default :book_cap_refs, :type_participation, :Autor
  end

  def down
    change_column_default :book_cap_refs, :type_participation, nil
  end
end
