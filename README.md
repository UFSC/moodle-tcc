Sistema de TCCs
===============

Sistema de controle e criação de TCCs dos estudantes da UNA-SUS curso Saúde da Família.

Esta ferramenta permite que os estudantes acessem via Moodle (LTI) esta ferramenta e
desenvolvam o TCC em duas atividades: 'portfólio' e 'tcc'.


Instalação
----------

1. Criar arquivos yml baseados nos arquivos: database.yml.example, moodle.yml.example e tcc_config.yml.example
2. sudo apt-get install qt4-qmake libqt4-dev # For capybara webkit driver
2. bundle install
3. rake db:migrate


Rodar testes
------------

1. rake db:test:prepare
2. rake spec