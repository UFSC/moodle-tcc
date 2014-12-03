Sistema de TCCs
===============

[![build
status](https://gitlabci.setic.ufsc.br/projects/3/status.png?ref=master)](https://gitlabci.setic.ufsc.br/projects/3?ref=master)

Sistema de controle e criação de TCCs dos estudantes da UNA-SUS curso Saúde da Família.

Esta ferramenta permite que os estudantes acessem via Moodle (LTI) esta ferramenta e
desenvolvam o TCC em duas atividades: **portfólio** e **tcc**.


Instalação
----------

Esta aplicação depende da instalação de algumas dependências externas
para seu completo funcionamento.

Os pacotes do QT4 são necessários para a instalação do Capybara, que é
utilizado para rodar os testes de interface.

Para geração correta do TCC em PDF é necessário instalar uma distribuição do LaTex
juntamente com o Abntex2. A instalação do LaTex é diferente no Ubuntu e no Mac OS X.


### Dependências do Ubuntu: ###

    sudo apt-get install -y phantomjs imagemagick libmagickwand-dev graphviz


### Instalação do Tex Live (Ubuntu)

No Ubuntu vamos utilizar a distribuição [Tex Live](http://www.tug.org/texlive/acquire-netinstall.html)

    wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
    tar zxvf install-tl-unx.tar.gz

    # O nome da pasta vai depender da data em que for baixado, o final segue o formato aaammdd
    cd install-tl-2*
    ./install-tl

Após a instalação é necessário incluir o TexLive no PATH (~/.bashrc ou ~/.zshrc):

    PATH=/usr/local/texlive/2014/bin/x86_64-linux:$PATH

Para que o PATH também seja incluído pro "sudo", edite o arquivo "/etc/sudoers":

    # Mudar esta linha:
    Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

    # Para:
    Defaults        secure_path="/usr/local/texlive/2013/bin/x86_64-linux:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"


### Instalação do MacTex (Mac OS X)

Baixar e instalar a distribuição [MacTex](http://tug.org/mactex/):

[Download MacTex.pkg](http://mirror.ctan.org/systems/mac/mactex/MacTeX.pkg)
[ 2.3G	- 30 May 2013 ]

Instalar o Graphviz (opcional): `brew install graphviz`

### Instalação do Abntex2 (Ubuntu e Mac OS X)

A instalação é feita pelo próprio gerenciador de pacotes do LaTex (tlmgr):

    sudo tlmgr update --self
    sudo tlmgr install abntex2 selnolig
    sudo texhash

Para concluir é preciso alterar uma variavel de configuração do texmf.cnf:

    sudo vim /usr/local/texlive/2013/texmf-dist/web2c/texmf.cnf

    # Procurar pelo trexo abaixo: (próximo da linha 598)
    openout_any = p

    # trocar para:
    openout_any = a

### Instalação e configuração da aplicação: ###

Criar arquivos yml baseados nos arquivos: 
 
* database.yml.example
* moodle.yml.example 
* tcc_config.yml.example (Verifique o endereço da sua instalação do Moodle na variavel **moodle_url**)
* email.yml.example

Instalar gems e executar a migração do banco:

    bundle install
    rake db:migrate


Rodar testes
------------

1. rake db:test:prepare
2. rake spec


Componentes e Integração
------------------------

### Javascript

Este projeto utiliza o editor [CKEditor](http://ckeditor.com/) disponibilizado pela gem 
[galetahub/ckeditor](https://github.com/galetahub/ckeditor) que realiza diversos procedimentos para facilitar a 
implantação do mesmo em um projeto Rails.

Nós utilizamos dois plugins adicionais aos que são disponibilizados por padrão pelo CKEditor:

* [Auto Grow](https://gitlab.setic.ufsc.br/tcc-unasus/ckeditor-autogrow): responsável por aumentar dinamicamente a altura do editor de texto
* [Citação](https://gitlab.setic.ufsc.br/tcc-unasus/ckeditor-citacao): plugin próprio para disponibilizar marcação de citação


### LTI

O padrão LTI é gerenciado pela IMS Global, que fornece uma ferramenta
para auxiliar a validação da implementação:
http://validator.imsglobal.org/

A implementação de LTI utilizada e disponibilizada pela "Instructureit"
possui alguns caveats:

* A URL no Moodle deve vir com uma / no final, pois o Rails inclui essa
  barra independente dela existir ou não na URL original, e caso isso
  não seja seguido, teremos uma assinatura inválida
  
Gerar documentação
------------------

### State Machine

Para gerar a imagem da máquina de estados definida, use o comando abaixo:

    rake state_machine:draw CLASS=Abstract
    
Será gerada a imagem chamada **Abstract_state.png**