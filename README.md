Sistema de TCCs
===============

Sistema de controle e criação de TCCs dos estudantes da UNA-SUS curso Saúde da Família.

Esta ferramenta permite que os estudantes acessem via Moodle (LTI) esta ferramenta e
desenvolvam o TCC em duas atividades: 'portfólio' e 'tcc'.


Instalação
----------

Criar arquivos yml baseados nos arquivos: 
 
* database.yml.example
* moodle.yml.example 
* tcc_config.yml.example (Verifique o endereço da sua instalação do Moodle na variavel **server** e **instance\_guid**)
* email.yml.example

Instalar pacotes necessários e rodar comandos de instalação da aplicação Rails:

    sudo apt-get install qt4-qmake libqt4-dev
    bundle install
    rake db:migrate

Os pacotes do QT4 são necessários para a instalação do Capybara, que é utilizado para rodar os testes de interface

Rodar testes
------------

1. rake db:test:prepare
2. rake spec
