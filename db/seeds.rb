# encoding: utf-8

# Helper para realizar a criação e popular TccDefinitions, ChapterDefinitions
def create_or_update_tcc_definitions(internal_name: internal_name(), course_id: course_id(), 
                                     activity_url: activity_url(), moodle_instance_id: moodle_instance_id(), 
                                     minimum_references: minimum_references(), definitions: definitions() )

  # Numero de operações para criação de Capítulos + 1 (Tcc)
  operations_count = definitions.flatten.flatten.count+1

  # Inicia o processo de criação das definições de TCC e Capítulos
  Progress.start("TCC Definition: #{internal_name}", operations_count) do
    td = TccDefinition.where(moodle_instance_id: moodle_instance_id)
    if (td.nil? || td.empty?)
      # deve criar
      tcc_def = TccDefinition.create_with(internal_name: internal_name,
                                          activity_url: activity_url,
                                          course_id: course_id,
                                          minimum_references: minimum_references).find_or_create_by(moodle_instance_id: moodle_instance_id)
    else
      # deve atualizar
      td.first.update_attributes({internal_name: internal_name,
                                            activity_url: activity_url,
                                            course_id: course_id,
                                            moodle_instance_id: moodle_instance_id,
                                            minimum_references: minimum_references
                                           })
      tcc_def = td.first
    end

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
                                 minimum_references: 6,
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
                                 minimum_references: 6,
                                 activity_url: 'https://unasus2.moodle.ufsc.br/mod/lti/view.php?id=5300')

#
# TCC Definition - Curso de Especialização Multiprofissional Na Atenção Básica 2015 (21000110) - Metodologia TCC
#
definition = [
    {title: 'Introdução', coursemodule_id: 7178, is_numbered_title: true, verify_references: true},
    {title: 'Objetivos',  coursemodule_id: 7179, is_numbered_title: true, verify_references: false},
    {title: 'Revisão da Literatura',             is_numbered_title: true, verify_references: true},
    {title: 'Metodologia',                       is_numbered_title: true, verify_references: false},
    {title: 'Resultados Esperados',              is_numbered_title: true, verify_references: false}
]

# How to find moodle_instance_id value.
#
# select id AS moodle_instance_id
#   from moodle_unasus2.lti
#  where course = 329
#
# or
#
# production log = "resource_link_id=15"
#

create_or_update_tcc_definitions(internal_name: 'Metodologia (210000110)',
                                 definitions: definition,
                                 course_id: 329,
                                 moodle_instance_id: 15,
                                 minimum_references: 6,
                                 activity_url: 'https://unasus2.moodle.ufsc.br/mod/lti/view.php?id=7265')
