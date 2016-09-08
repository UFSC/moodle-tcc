Sistema de TCCs
===============

[![build
status](https://gitlabci.setic.ufsc.br/projects/3/status.png?ref=master)](https://gitlabci.setic.ufsc.br/projects/3?ref=master)
[![Dependency Status](https://gemnasium.com/badges/github.com/UFSC/moodle-tcc.svg)](https://gemnasium.com/github.com/UFSC/moodle-tcc)


É um sistema de controle e auxílio à criação de TCCs pelos estudantes. Irá auxiliar também os orientadores, na correção e troca de informações com seus orientados.

Esta ferramenta permite que os estudantes acessem via Moodle (LTI) esta ferramenta, e
desenvolvam o TCC importando o material previamente produzidos por eles mesmos, em atividades de "texto online".

O texto será formatado no padrão ABNT, inclusive as referências, que serão cadastradas na própria ferramenta de TCC.  

Instalação
----------

Esta aplicação depende da instalação de algumas dependências externas
para seu completo funcionamento.

Os pacotes do "phantomjs" são necessários para a instalação do Capybara, que é
utilizado para rodar os testes de interface.

Para geração correta do TCC em PDF é necessário instalar uma distribuição do LaTex
juntamente com o Abntex2. A instalação do LaTex é diferente no Ubuntu e no Mac OS X.

### Instalação automatizada

**Em breve será disponibilizada instalação automatizada via [Chef](https://www.chef.io/chef/) utilizando a 
instalação local, por intermédio do chef-solo.**
 
Esta automação servirá tanto para o servidor quanto para a máquina de desenvolvimento e testes. 

### Dependências do Ubuntu: ###

    sudo apt-get install -y phantomjs imagemagick libmagickwand-dev graphviz redis-server

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
* email.yml.example
* errbit.yml.example
* moodle.yml.example
* newrelic.yml.example 
* tcc_config.yml.example (Verifique o endereço da sua instalação do Moodle na variavel **moodle_url**)

Instalar gems e executar a migração do banco:

    bundle install
    rake db:migrate


Desenvolvimento e testes
------------------------

Para rodar testes, utilize o comando a seguir, definindo opcionalmente a variavel de ambiente COVERAGE:

```
COVERAGE=true rake spec
```

Quando definido COVERAGE=true, será analizado também cobertura de testes da aplicação.

Esta aplicação usa [Rails 4.1](http://guides.rubyonrails.org/) e para tornar o desenvolvimento mais rápido,
realiza o pré-load da aplicação usando [Spring](https://github.com/rails/spring).

O Spring, apesar de facilitar o desenvolvimento diminuindo o tempo de carregamento da aplicação, pode gerar
conflitos quando mudanças mais profundas (initializers, mudanças de configuração e gems) forem executadas,
necessitando ser reiniciado.

Se alguma mudança não refletir no momento de desenvolvimento, basta desligar o mesmo e reiniciar a aplicação:

```
spring stop
```

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
  
Contribuições

    Bruno Martinenghi Sidronio de Freitas (brunosfreitas@gmail.com )
    Bruno Saibro Silveira (djbrunosilveira@gmail.com)
    Fábio César Ariati (fabiocariati@gmail.com)
    Jorge Almeida Bastos Júnior (jorgealmeidajunior@gmail.com)
    Luiz Henrique Américo Salazar (lhenriquesalazar@yahoo.com.br) 
    Osmar Floriano Guimarães de Oliveira (caca.ufsc@gmail.com)
    Wagner Daufenbach do Amaral (wagnerdamaral@gmail.com)

Autores

    Universidade Aberta do SUS
    Roberto Silvino (roberto.silvino@ufsc.br)
    Gabriel Mazetto (brodock@gmail.com)
    
Este projeto utiliza a licença MIT-LICENSE. 
