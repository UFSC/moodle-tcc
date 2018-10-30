FROM robertosilvino/latex_ubuntu-ruby-base:latest

RUN addgroup --gid 9999 app \
    && adduser --uid 9999 --gid 9999 --disabled-password --gecos "Application" app \
    && usermod -L app \
    && mkdir -p /home/app/.ssh \
    && chmod 700 /home/app/.ssh \
    && chown app:app /home/app/.ssh

USER app

WORKDIR ${APP_DIR}

COPY --chown=app:app . .

# security issue
RUN rm -rf .git

USER root

RUN mkdir -p ${APP_DIR}/public/assets && \
    mkdir -p ${APP_DIR}/public/uploads && \
    mkdir -p ${APP_DIR}/log && \
    mkdir -p ${APP_DIR}/shared && \
    ln -s ${APP_DIR}/log ${APP_DIR}/shared/. && \
    ln -s ${APP_DIR}/public/assets ${APP_DIR}/shared/. && \
    ln -s ${APP_DIR}/public/uploads ${APP_DIR}/shared/. && \
    ln -s ${GEM_PATH} ${APP_DIR}/shared/.

RUN chmod -R 777 $GEM_HOME

RUN /bin/bash -l -c 'chown -R app:app  ${APP_HOME}'

#RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER app

RUN gem install --no-rdoc --no-ri bundler rake && \
    bundle config --global jobs "$(($(getconf _NPROCESSORS_ONLN)*2))" && \
    bundle config --global retry 2

VOLUME [ "${APP_DIR}/shared/log"]
VOLUME [ "${APP_DIR}/shared/uploads"]
VOLUME [ "${APP_DIR}/shared/bundle"]
VOLUME [ "${APP_DIR}/shared/assets"]

EXPOSE $RACK_PORT

#mkdir -p /home/deploy/homologacao-tcc.unasus.ufsc.br/releases/20181101055726 /home/deploy/homologacao-tcc.unasus.ufsc.br/releases/20181101055726/tmp /home/deploy/homologacao-tcc.unasus.ufsc.br/releases/20181101055726/vendor /home/deploy/homologacao-tcc.unasu…
#rm -rf /home/deploy/homologacao-tcc.unasus.ufsc.br/releases/20181101055726/log
#ln -s /home/deploy/homologacao-tcc.unasus.ufsc.br/shared/log /home/deploy/homologacao-tcc.unasus.ufsc.br/releases/20181101055726/log
#ln -s /home/deploy/homologacao-tcc.unasus.ufsc.br/shared/tmp/pids /home/deploy/homologacao-tcc.unasus.ufsc.br/releases/20181101055726/tmp/pids
#ln -s /home/deploy/homologacao-tcc.unasus.ufsc.br/shared/tmp/cache /home/deploy/homologacao-tcc.unasus.ufsc.br/releases/20181101055726/tmp/cache
#ln -s /home/deploy/homologacao-tcc.unasus.ufsc.br/shared/tmp/sockets /home/deploy/homologacao-tcc.unasus.ufsc.br/releases/20181101055726/tmp/sockets
