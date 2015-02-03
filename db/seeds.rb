# encoding: utf-8

# Helper para realizar a criação e popular TccDefinitions, HubDefinitions, DiaryDefinitions
def create_or_update_tcc_definitions(internal_name: internal_name, course_id: course_id, activity_url: activity_url,
                                     moodle_instance_id: moodle_instance_id, definitions: definitions)

  # Numero de operações para criação de Capítulos + 1 (Tcc)
  operations_count = definitions.flatten.flatten.count+1

  # Inicia o processo de criação das definições de TCC e Capítulos
  Progress.start("TCC Definition: #{internal_name}", operations_count) do

    tcc_def = TccDefinition.create_with(internal_name: internal_name,
                                        activity_url: activity_url,
                                        moodle_instance_id: moodle_instance_id).find_or_create_by(course_id: course_id)
    Progress.step

    definitions.each_with_index do |chapter_definitions, chapter_index|
      cd = ChapterDefinition.where(position: chapter_index+1,
                              tcc_definition_id: tcc_def.id)
      if (cd.nil? || cd.empty?)
        # deve criar
        ChapterDefinition.create_with(chapter_definitions).find_or_create_by(position: chapter_index+1,
                                                                             tcc_definition_id: tcc_def.id)
      else
        # deve atualizar
        cd.first.update_attributes(chapter_definitions)
      end
      Progress.step
    end

  end
end

#
# TCC Definition - Turma A (210000092)
#
definition = [
    {title: 'Introdução', coursemodule_id: 5206, is_numbered_title: true, verify_references: true},
    {title: 'Objetivos',  coursemodule_id: 5207, is_numbered_title: true, verify_references: false},
    {title: 'Revisão da Literatura',             is_numbered_title: true, verify_references: true},
    {title: 'Metodologia',                       is_numbered_title: true, verify_references: false},
    {title: 'Resultados Esperados',              is_numbered_title: true, verify_references: false}
]
create_or_update_tcc_definitions(internal_name: 'Turma A (210000092)',
                                 definitions: definition,
                                 course_id: 230,
                                 moodle_instance_id: 8,
                                 activity_url: 'https://unasus2.moodle.ufsc.br/mod/lti/view.php?id=3322')
#
# TCC Definition - Turma B (210000092)
#
definition = [
    {title: 'Introdução', coursemodule_id: 5203, is_numbered_title: true,  verify_references: true},
    {title: 'Objetivos',  coursemodule_id: 5204, is_numbered_title: true,  verify_references: false},
    {title: 'Revisão da Literatura',             is_numbered_title: true,  verify_references: true},
    {title: 'Metodologia',                       is_numbered_title: true,  verify_references: false},
    {title: 'Resultados Esperados',              is_numbered_title: true,  verify_references: false}
]
create_or_update_tcc_definitions(internal_name: 'Turma B (210000092)',
                                 definitions: definition,
                                 course_id: 258,
                                 moodle_instance_id: 9,
                                 activity_url: 'https://unasus2.moodle.ufsc.br/mod/lti/view.php?id=5300')