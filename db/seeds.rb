# encoding: utf-8
require 'open-uri'

# Helper para realizar a criação e popular Instituições
def create_or_update_internal_institutions(institution_name: institution_name(),
                                           city: city(),
                                           logo_width: logo_width(),
                                           local_image_file_name: local_image_file_name()
)

  int_inst = nil
  # Numero de operações para criação
  operations_count = 1

  # Inicia o processo de criação das definições de Instituições
  Progress.start("Institution: #{institution_name} - #{city}", operations_count) do
    ii = InternalInstitution.where({institution_name: institution_name, city: city})

    image_memory = open(local_image_file_name)
    if (ii.nil? || ii.empty?)
      # deve criar
      int_inst = InternalInstitution.create_with(logo_width: logo_width,
                                                 image: image_memory
      ).find_or_create_by({institution_name: institution_name,
                           city: city})
    else
      # deve atualizar
      ii.first.update_attributes({institution_name: institution_name,
                                  city: city,
                                  logo_width: logo_width,
                                  image: image_memory})
      int_inst = ii.first
    end
    Progress.step
  end

  int_inst
# Universidade Federal de Santa Catarina

end

# Helper para realizar a criação e popular Cursos
def create_or_update_internal_courses(internal_institution_id: internal_institution_id(),
                                      course_name: course_name(),
                                      department_name: department_name(),
                                      center_name: center_name(),
                                      coordinator_name: coordinator_name(),
                                      presentation_data: presentation_data(),
                                      approval_data: approval_data(),
                                      coordinator_gender: coordinator_gender())

  int_course = nil
  # Numero de operações para criação
  operations_count = 1

  # Inicia o processo de criação das definições de Cursos
  Progress.start("Course: #{course_name} - #{department_name}", operations_count) do
    ic = InternalCourse.where({course_name: course_name, department_name: department_name, center_name: center_name})

    if (ic.nil? || ic.empty?)
      # deve criar
      int_course = InternalCourse.create_with(internal_institution_id: internal_institution_id,
                                              coordinator_name: coordinator_name,
                                              presentation_data: presentation_data,
                                              approval_data: approval_data,
                                              coordinator_gender: coordinator_gender
      ).find_or_create_by({course_name: course_name,
                           department_name: department_name,
                           center_name: center_name})
    else
      # deve atualizar
      ic.first.update_attributes({internal_institution_id: internal_institution_id,
                                  course_name: course_name,
                                  department_name: department_name,
                                  center_name: center_name,
                                  coordinator_name: coordinator_name,
                                  presentation_data: presentation_data,
                                  approval_data: approval_data,
                                  coordinator_gender: coordinator_gender})
      int_course = ic.first
    end
    Progress.step
  end

  int_course

# CURSO DE ESPECIALIZAÇÃO MULTIPROFISSIONAL NA ATENÇÃO BÁSICA
# DEPARTAMENTO DE SAÚDE PÚBLICA
# CENTRO DE CIÊNCIAS DA SAÚDE
# Profa Dra Elza Berger Salema Coelho
# Monografia apresentada ao Curso de Especialização Multiprofissional na Atenção Básica da Universidade Federal de Santa Catarina, como requisito para obtenção do título de Especialista na Atenção Básica.
# Essa monografia foi julgada adequada para obtenção do título de “Especialista na atenção básica”, e aprovada em sua forma final pelo Departamento de Saúde Pública da Universidade Federal de Santa Catarina.

end
# Helper para realizar a criação e popular TccDefinitions, ChapterDefinitions
def create_or_update_tcc_definitions(internal_name: internal_name(),
                                     course_id: course_id(),
                                     internal_course_id: internal_course_id(),
                                     activity_url: activity_url(),
                                     moodle_instance_id: moodle_instance_id(),
                                     minimum_references: minimum_references(),
                                     pdf_link_hours: pdf_link_hours(),
                                     auto_save_minutes: auto_save_minutes(),
                                     advisor_nomenclature: advisor_nomenclature(),
                                     definitions: definitions()
)

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
                                          internal_course_id: internal_course_id,
                                          minimum_references: minimum_references,
                                          pdf_link_hours: pdf_link_hours,
                                          advisor_nomenclature: advisor_nomenclature,
                                          auto_save_minutes: auto_save_minutes
      ).find_or_create_by(moodle_instance_id: moodle_instance_id)
    else
      # deve atualizar
      td.first.update_attributes({internal_name: internal_name,
                                  activity_url: activity_url,
                                  course_id: course_id,
                                  internal_course_id: internal_course_id,
                                  moodle_instance_id: moodle_instance_id,
                                  minimum_references: minimum_references,
                                  pdf_link_hours: pdf_link_hours,
                                  advisor_nomenclature: advisor_nomenclature,
                                  auto_save_minutes: auto_save_minutes
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

int_institution = create_or_update_internal_institutions(institution_name: 'Universidade Federal de Duis Posuere',
                                                         city: 'Florianopolis',
                                                         logo_width: 70,
                                                         local_image_file_name: Rails.root.join('app/assets/images/logo.png') )


int_course = create_or_update_internal_courses(internal_institution_id: int_institution.id,
                                               course_name: 'CURSO DE ESPECIALIZAÇÃO MULTIPROFISSIONAL NA VESTIBULUM',
                                               department_name: 'DEPARTAMENTO PELLENTESQUE',
                                               center_name: 'CENTRO DE CIÊNCIAS DA CONDIMENTUM',
                                               coordinator_name: 'Profa Dra Suspendisse Ultrices Vehicula Diam',
                                               presentation_data: 'Monografia apresentada ao Curso de Especialização Multiprofissional na Vestibulum da Universidade Federal de Duis Posuere, como requisito para obtenção do título de Especialista na Vestibulum.',
                                               approval_data: 'Essa monografia foi julgada adequada para obtenção do título de “Especialista na vestibulum”, e aprovada em sua forma final pelo Departamento Pellentesque da Universidade Federal de Duis Posuere.',
                                               coordinator_gender: 'f')

#
# Teste de TCC - Turma 1
#
definition = [
    {title: 'Introdução', coursemodule_id: 3, is_numbered_title: true, verify_references: true},
    # {title: 'Introdução',                     is_numbered_title: true, verify_references: true},
    {title: 'Objetivos',                      is_numbered_title: true, verify_references: false},
    {title: 'Revisão da Literatura',          is_numbered_title: true, verify_references: true},
    {title: 'Metodologia',                    is_numbered_title: true, verify_references: false},
    {title: 'Resultados Esperados',           is_numbered_title: true, verify_references: false}
]

# para saber o moodle_instance_id, execute:
#
# select id AS moodle_instance_id
#   from moodle_unasus2.lti
#  where course = 2
#

create_or_update_tcc_definitions(internal_name: 'Teste de TCC - Turma 1',
                                 definitions: definition,
                                 course_id: 2,
                                 internal_course_id: int_course.id,
                                 moodle_instance_id: 1,
                                 minimum_references: 6,
                                 activity_url: 'http://homologacao-moodle35.ifes.br/mod/lti/view.php?id=2',
                                 pdf_link_hours: 2,
                                 advisor_nomenclature: 'orientador',
                                 auto_save_minutes: 0 )

