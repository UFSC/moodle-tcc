Sistema de TCCs
===============

Sistema de controle e criação de TCCs dos estudantes da UNA-SUS curso Saúde da Família.

Esta ferramenta permite que os estudantes acessem via Moodle (LTI) esta ferramenta e
desenvolvam o TCC em duas atividades: **portfólio** e **tcc**.


Instalação
----------

Esta aplicação depende da instalação de algumas dependências externas
para seu completo funcionamento.

Os pacotes do QT4 são necessários para a instalação do Capybara, que é
utilizado para rodar os testes de interface.

### Dependências do Ubuntu: ###

    sudo apt-get install -y qt4-qmake libqt4-dev imagemagick libmagickwand-dev


### Instalação e configuração da aplicação: ###

Criar arquivos yml baseados nos arquivos: 
 
* database.yml.example
* moodle.yml.example 
* tcc_config.yml.example (Verifique o endereço da sua instalação do Moodle na variavel **server** e **instance\_guid**)
* email.yml.example

Instalar gems e executar a migração do banco:

    bundle install
    rake db:migrate


Rodar testes
------------

1. rake db:test:prepare
2. rake spec
