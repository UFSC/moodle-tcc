# encoding: utf-8

# Helper para realizar a criação e popular TccDefinitions, HubDefinitions, DiaryDefinitions
def create_or_update_tcc_definitions(title, hub_diaries, course_id, activity_url)

  # Numero de operações para criação de Hubs + Diários + 1 (Tcc)
  num_operations = hub_diaries.flatten.flatten.count+1

  Progress.start("TCC Definition: #{title}", num_operations) do
    tcc_def = TccDefinition.find_or_initialize_by_title(title: title)
    tcc_def.course_id = course_id
    tcc_def.activity_url = activity_url
    tcc_def.save!
    Progress.step

    hub_diaries.each_with_index do |(hub_name, diaries), hub_index|
      hub_def = HubDefinition.find_or_initialize_by_position_and_tcc_definition_id( position: hub_index+1, tcc_definition_id: tcc_def.id)
      hub_def.moodle_shortname = diaries[0][:shortname]
      hub_def.subtitle = hub_name[1]
      hub_def.save
      Progress.step

      diaries.each_with_index do |diary, diary_index|
        Progress.step do
          diary_id = diary.first[0]
          diary_name = diary.first[1]

          next if diary_id.nil?

          DiaryDefinition.find_or_create_by_position_and_hub_definition_id(external_id: diary_id, hub_definition_id: hub_def.id, position: diary_index+1, title: diary_name)
        end
      end
    end

  end
end

#
# TCC Definition - Turma A
#
definition = {
    ['Eixo 1', 'Reconhecimento da Realidade'] => [{1264 => 'Saúde e sociedade'}, {1092 => 'Epidemiologia'}],
    ['Eixo 2', 'O trabalho da atenção Básica'] => [{1151 => 'Planejamento na Atenção Básica'}, {1133 => 'Gestão e Avaliação na Atenção Básica'}, {1163 => 'Processo de Trabalho na Atenção Básica'}],
    ['Eixo 3 - ESF', 'A assistência na Atenção Básica'] => [
        {1940 => 'Atenção Integral à Saúde da Criança', shortname: 'SPB110069-21000077ES (20131)'},
        {2055 => 'Atenção Integral à Saúde da Mulher'}, # shortname: 'SPB110070-21000077ES (20131)'
        {2637 => 'Atenção Integral à Saúde do Adulto'}, # shortname: 'SPB110071-21000077ES (20131)'
        {2693 => 'Atenção Integral à Saúde do Idoso'} # shortname: 'SPB110072-21000077ES (20131)'
    ],
    ['Eixo 3 - NASF', 'A assistência na Atenção Básica'] => [
        {2258 => 'Apoio Matricial', shortname: 'SPB110073-21000077ES (20131)'},
        {1994 => 'Clínica Ampliada'}, # shortname: 'SPB110074-21000077ES (20131)'
        {2014 => 'Projeto Terapêutico Singular'}, # shortname: 'SPB110075-21000077ES (20131)'
        {2023 => 'Projeto de Saúde no Território'} # shortname: 'SPB110076-21000077ES (20131)'
    ]

}
activity_url = 'https://unasus2.moodle.ufsc.br/mod/lti/view.php?id=3321'
create_or_update_tcc_definitions('Turma A', definition, 101, activity_url)

#
# TCC Definition - Turma B
#
definition = {
    ['Eixo 1', 'Reconhecimento da Realidade'] => [{1550 => 'Saúde e sociedade'}, {1569 => 'Epidemiologia'}],
    ['Eixo 2', 'O trabalho da atenção Básica'] => [{1786 => 'Planejamento na Atenção Básica'}, {1803 => 'Gestão e Avaliação na Atenção Básica'}, {2431 => 'Processo de Trabalho na Atenção Básica'}],
    ['Eixo 3 - ESF', 'A assistência na Atenção Básica'] => [
        {2327 => 'Atenção Integral à Saúde da Criança', shortname: 'SPB110069-21000077ES (20132)'}, # shortname: 'SPB110069-21000077ES (20132)'
        {2388 => 'Atenção Integral à Saúde da Mulher'}, # shortname: 'SPB110070-21000077ES (20132)'
        {2078 => 'Atenção Integral à Saúde do Adulto'}, # shortname: 'SPB110071-21000077ES (20132)'
        {2124 => 'Atenção Integral à Saúde do Idoso'} # shortname: 'SPB110072-21000077ES (20132)'
    ],
    ['Eixo 3 - NASF', 'A assistência na Atenção Básica'] => [
        {2322 => 'Apoio Matricial', shortname: 'SPB110073-21000077ES (20132)'}, # shortname: 'SPB110073-21000077ES (20132)'
        {2599 => 'Clínica Ampliada'}, # shortname: 'SPB110074-21000077ES (20132)'
        {2661 => 'Projeto Terapêutico Singular'}, # shortname: 'SPB110075-21000077ES (20132)'
        {2568 => 'Projeto de Saúde no Território'} # shortname: 'SPB110076-21000077ES (20132)'
    ]
}
activity_url = 'https://unasus2.moodle.ufsc.br/mod/lti/view.php?id=3322'
create_or_update_tcc_definitions('Turma B', definition, 102, activity_url)


#
# TccDefinition para Turma A
#

# Turma A - ESF
#definition = {
#    'Eixo 1' => [{1264 => 'Saúde e sociedade'}, {1092 => 'Epidemiologia'}],
#    'Eixo 2' => [{1151 => 'Planejamento na Atenção Básica'}, {1133 => 'Gestão e Avaliação na Atenção Básica'}, {1163 => 'Processo de Trabalho na Atenção Básica'}],
#    'Eixo 3' => [{1940 => 'Atenção Integral à Saúde da Criança'}, {2055 => 'Atenção Integral à Saúde da Mulher'}, {2078 => 'Atenção Integral à Saúde do Adulto'}, {2124 => 'Atenção Integral à Saúde do Idoso'}]
#}
#create_tcc_definitions('Turma A - ESF', definition)
#
## Turma A - NASF
#definition = {
#    'Eixo 1' => [{1264 => 'Saúde e sociedade'}, {1092 => 'Epidemiologia'}],
#    'Eixo 2' => [{1151 => 'Planejamento na Atenção Básica'}, {1133 => 'Gestão e Avaliação na Atenção Básica'}, {1163 => 'Processo de Trabalho na Atenção Básica'}],
#    'Eixo 3' => [{2258 => 'Apoio Matricial'}, {1994 => 'Clínica Ampliada'}, {2014 => 'Projeto Terapêutico Singular'}, {2023 => 'Projeto de Saúde no Território'}]
#}
#create_tcc_definitions('Turma A - NASF', definition)


#
# TccDefinition para Turma B
#

# Turma B - ESF - Enfermagem
#definition = {
#    'Eixo 1' => [{1550 => 'Saúde e sociedade'}, {1569 => 'Epidemiologia'}],
#    'Eixo 2' => [{1803 => 'Planejamento na Atenção Básica'}, {1786 => 'Gestão e Avaliação na Atenção Básica'}, {2431 => 'Processo de Trabalho na Atenção Básica'}],
#    'Eixo 3' => [{2327 => 'Atenção Integral à Saúde da Criança'}, {2328 => 'Atenção Integral à Saúde da Mulher'}, {nil => 'Atenção Integral à Saúde do Adulto'}, {nil => 'Atenção Integral à Saúde do Idoso'}]
#}
#create_tcc_definitions('Turma B - ESF - Enfermagem', definition)
#
## Turma B - ESF - Medicina
#definition = {
#    'Eixo 1' => [{1550 => 'Saúde e sociedade'}, {1569 => 'Epidemiologia'}],
#    'Eixo 2' => [{1803 => 'Planejamento na Atenção Básica'}, {1786 => 'Gestão e Avaliação na Atenção Básica'}, {2431 => 'Processo de Trabalho na Atenção Básica'}],
#    'Eixo 3' => [{2327 => 'Atenção Integral à Saúde da Criança'}, {2396 => 'Atenção Integral à Saúde da Mulher'}, {nil => 'Atenção Integral à Saúde do Adulto'}, {nil => 'Atenção Integral à Saúde do Idoso'}]
#}
#create_tcc_definitions('Turma B - ESF - Medicina', definition)
#
## Turma B - ESF - Odontologia
#definition = {
#    'Eixo 1' => [{1550 => 'Saúde e sociedade'}, {1569 => 'Epidemiologia'}],
#    'Eixo 2' => [{1803 => 'Planejamento na Atenção Básica'}, {1786 => 'Gestão e Avaliação na Atenção Básica'}, {2431 => 'Processo de Trabalho na Atenção Básica'}],
#    'Eixo 3' => [{2327 => 'Atenção Integral à Saúde da Criança'}, {2404 => 'Atenção Integral à Saúde da Mulher'}, {nil => 'Atenção Integral à Saúde do Adulto'}, {nil => 'Atenção Integral à Saúde do Idoso'}]
#}
#create_tcc_definitions('Turma B - ESF - Odontologia', definition)
#
## Turma B - NASF
#definition = {
#    'Eixo 1' => [{1550 => 'Saúde e sociedade'}, {1569 => 'Epidemiologia'}],
#    'Eixo 2' => [{1803 => 'Planejamento na Atenção Básica'}, {1786 => 'Gestão e Avaliação na Atenção Básica'}, {2431 => 'Processo de Trabalho na Atenção Básica'}],
#    'Eixo 3' => [{2322 => 'Apoio Matricial'}, {nil => 'Clínica Ampliada'}, {nil => 'Projeto Terapêutico Singular'}, {nil => 'Projeto de Saúde no Território'}]
#}
#create_tcc_definitions('Turma B - NASF', definition)
