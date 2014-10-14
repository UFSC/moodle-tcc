class CreateTccDefinitions < ActiveRecord::Migration
  def change
    create_table :tcc_definitions do |t|
      t.string :internal_name # Utilizado internamente para identificar o "template de TCC"
      t.string :activity_url # URL da atividade para envio de e-mail
      t.integer :course_id # Curso Moodle relacionado a ativade LTI
      t.date :defense_date

      t.timestamps
    end
  end
end
