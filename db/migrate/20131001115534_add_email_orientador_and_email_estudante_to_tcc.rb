class AddEmailOrientadorAndEmailEstudanteToTcc < ActiveRecord::Migration
  def change
    add_column :tccs, :email_estudante, :string
    add_column :tccs, :email_orientador, :string
  end
end
