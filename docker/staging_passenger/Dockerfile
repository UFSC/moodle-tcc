FROM ufsc/passenger_ufsc-tcc_base:latest

RUN bash -lc 'echo "source /usr/local/rvm/scripts/rvm" >> /home/app/.bashrc'

COPY --chown=app:app . ${APP_DIR}

# security issue
#RUN rm -rf .git

# Habilita Nginx
RUN rm -f /etc/service/nginx/down /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default

# Configura nginx e certificado ssl
RUN cp docker/staging_passenger/config/nginx-app.conf /etc/nginx/sites-enabled/default && \
    mkdir -p /etc/ssl/certs_app && \
    cp docker/staging_passenger/config/cert.* /etc/ssl/certs_app

# Cria diretórios auxiliares e links simbólicos para volumes externos,
# para que possam ser persistidos
RUN mkdir -p ${APP_DIR}/public/uploads && \
    mkdir -p ${APP_DIR}/log && \
    mkdir -p ${APP_DIR}/shared && \
    mkdir -p ${APP_DIR}/public/assets && \
    mkdir -p ${APP_DIR}/tmp/pids && \
    mkdir -p ${APP_DIR}/tmp/cache/assets && \
    ln -s ${APP_DIR}/log ${APP_DIR}/shared/. && \
    ln -s ${APP_DIR}/public/uploads ${APP_DIR}/shared/. && \
    ln -s ${APP_DIR}/public/assets ${APP_DIR}/shared/.

RUN /bin/bash -l -c 'chown -R app:app  ${APP_HOME}'

# instala rvm com usuário root, e reinstala como app, para ajustar permissões
RUN bash -l -c "rvm install 2.2.10"

USER app

WORKDIR $APP_DIR

# reinstala rvm como usuário app para ajustar permissões
RUN bash -l -c "rvm reinstall 2.2.10" && \
    bash -l -c 'rvm --default use ruby-2.2.10' && \
    bash -l -c 'RAILS_ENV=${RAILS_ENV} gem install bundler --version 1.17.1 --no-rdoc --no-ri' && \
    bash -l -c 'RAILS_ENV=${RAILS_ENV} bundle config --global jobs "$(($(getconf _NPROCESSORS_ONLN)*2))"' && \
    bash -l -c 'RAILS_ENV=${RAILS_ENV} bundle config --global retry 2'

RUN bash -l -c 'ln -s ${GEM_HOME} ${APP_DIR}/shared/bundle'

VOLUME [ "${APP_DIR}/config"]
VOLUME [ "${APP_DIR}/shared/uploads"]
VOLUME [ "${APP_DIR}/shared/log"]
VOLUME [ "/etc/ssl/certs_app"]
VOLUME [ "${APP_DIR}/shared/bundle"]
VOLUME [ "${APP_DIR}/shared/assets"]
VOLUME [ "${APP_DIR}/tmp/cache/assets"]

USER root

EXPOSE $RACK_PORT
EXPOSE 80
EXPOSE 443
