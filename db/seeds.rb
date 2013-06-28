# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Seed da Turma A
tcc_def = TccDefinition.create(title: 'Turma A')

hub_def1 = HubDefinition.create(order: 1, title: 'Eixo 1', tcc_definition: tcc_def)
  DiaryDefinition.create(external_id: 1264, hub_definition: hub_def1, order: 1, title: 'Saúde e sociedade')
  DiaryDefinition.create(external_id: 1092, hub_definition: hub_def1, order: 2, title: 'Epidemiologia')

hub_def2 = HubDefinition.create(order: 2, title: 'Eixo 2', tcc_definition: tcc_def)
  DiaryDefinition.create(external_id: 1133, hub_definition: hub_def2, order: 1, title: 'Gestão e Avaliação na Atenção Básica')
  DiaryDefinition.create(external_id: 1151, hub_definition: hub_def2, order: 2, title: 'Planejamento na Atenção Básica')
  DiaryDefinition.create(external_id: 1163, hub_definition: hub_def2, order: 3, title: 'Processo de Trabalho na Atenção Básica')

hub_def3 = HubDefinition.create(order: 3, title: 'Eixo 3', tcc_definition: tcc_def)
  DiaryDefinition.create(external_id: 1940, hub_definition: hub_def3, order: 1, title: 'Atenção Integral na Saúde da Criança/ Apoio Matricial')
  DiaryDefinition.create(external_id: 2055, hub_definition: hub_def3, order: 2, title: 'Atenção Integral na Saúde da Mulher/Clínica Ampliada')
  DiaryDefinition.create(external_id: 2078, hub_definition: hub_def3, order: 3, title: 'Saúde do Adulto/Projeto Terapêutico Singular')
  DiaryDefinition.create(external_id: 2124, hub_definition: hub_def3, order: 4, title: 'Saúde do Idoso/Projeto de Saúde no Território')

# Seed da Turma B
tcc_def = TccDefinition.create(title: 'Turma B')

hub_def1 = HubDefinition.create(order: 1, title: 'Eixo 1', tcc_definition: tcc_def)
DiaryDefinition.create(external_id: 149, hub_definition: hub_def1, order: 1, title: 'Saúde e sociedade')
DiaryDefinition.create(external_id: 150, hub_definition: hub_def1, order: 2, title: 'Epidemiologia')

hub_def2 = HubDefinition.create(order: 2, title: 'Eixo 2', tcc_definition: tcc_def)
DiaryDefinition.create(external_id: 151, hub_definition: hub_def2, order: 1, title: 'Gestão e Avaliação na Atenção Básica')
DiaryDefinition.create(external_id: 152, hub_definition: hub_def2, order: 2, title: 'Planejamento na Atenção Básica')
DiaryDefinition.create(external_id: 153, hub_definition: hub_def2, order: 3, title: 'Processo de Trabalho na Atenção Básica')

hub_def3 = HubDefinition.create(order: 3, title: 'Eixo 3', tcc_definition: tcc_def)
DiaryDefinition.create(external_id: 154, hub_definition: hub_def3, order: 1, title: 'Atenção Integral na Saúde da Criança/ Apoio Matricial')
DiaryDefinition.create(external_id: 155, hub_definition: hub_def3, order: 2, title: 'Atenção Integral na Saúde da Mulher/Clínica Ampliada')
DiaryDefinition.create(external_id: 144, hub_definition: hub_def3, order: 3, title: 'Saúde do Adulto/Projeto Terapêutico Singular')
DiaryDefinition.create(external_id: 145, hub_definition: hub_def3, order: 4, title: 'Saúde do Idoso/Projeto de Saúde no Território')
