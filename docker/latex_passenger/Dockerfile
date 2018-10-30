FROM phusion/passenger-full
#FROM phusion/passenger-ruby22

ENV LANG pt_BR.UTF-8
ENV LANGUAGE pt_BR
ENV LC_CTYPE pt_BR.UTF-8
ENV LC_ALL pt_BR.UTF-8

### Ubuntu
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y git vim curl locales wget xzdec dirmngr gnupg \
            tzdata netcat \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt \
    && localedef -i pt_BR -c -f UTF-8 -A /usr/share/locale/locale.alias pt_BR.UTF-8

# https://www.digitalocean.com/community/tutorials/how-to-set-up-vsftpd-for-anonymous-downloads-on-ubuntu-16-04
#    && apt-get install -y git vim curl locales wget xzdec dirmngr gnupg build-essential mysql-client \
#     libmysqlclient-dev nodejs imagemagick tzdata netcat software-properties-common libcurl4-openssl-dev \

ENV TZ=America/Sao_Paulo

RUN apt-get update \
    && apt-get install -y texlive-full

RUN cd /usr/bin
RUN tlmgr init-usertree; exit 0
#RUN tlmgr option repository ftp://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2015/tlnet-final; exit 0 \
#RUN tlmgr option repository ftp://tug.org/historic/systems/texlive/2015/tlnet-final; exit 0 \
RUN tlmgr option repository ftp://150.162.9.144/pub/texlive_2015/tlnet-final; exit 0
RUN tlmgr update --self; exit 0

RUN tlmgr install abntex2 selnolig
RUN texhash

RUN cd /usr/share/texlive/texmf-dist/web2c \
    && sed 's/openout_any\s=\sp/openout_any = a/' texmf.cnf > new_texmf.cnf \
    && mv new_texmf.cnf texmf.cnf

