FROM robertosilvino/passenger_ufsc-tcc_base:latest

RUN bash -lc 'echo "source /usr/local/rvm/scripts/rvm" >> /home/app/.bashrc'

COPY --chown=app:app . ${APP_DIR}

USER app

WORKDIR ${APP_DIR}

# security issue
#RUN rm -rf .git

USER root

# Habilita Nginx
RUN rm -f /etc/service/nginx/down /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default

RUN cp docker/staging_passenger/config/nginx-app.conf /etc/nginx/sites-enabled/default

# TODO: rever shared para produção
RUN mkdir -p ${APP_DIR}/public/assets && \
    mkdir -p ${APP_DIR}/public/uploads && \
    mkdir -p ${APP_DIR}/log && \
    mkdir -p ${APP_DIR}/shared && \
    ln -s ${APP_DIR}/log ${APP_DIR}/shared/. && \
    ln -s ${APP_DIR}/public/assets ${APP_DIR}/shared/. && \
    ln -s ${APP_DIR}/public/uploads ${APP_DIR}/shared/.

#    ln -s ${APP_DIR}/public/uploads ${APP_DIR}/shared/. && \
#    ln -s ${GEM_HOME} ${APP_DIR}/shared/.

#    ln -s ${GEM_PATH} ${APP_DIR}/shared/.

#RUN chmod -R 777 $GEM_HOME

RUN /bin/bash -l -c 'chown -R app:app  ${APP_HOME}'

#RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER app

WORKDIR $APP_DIR

RUN bash -l -c "rvm install 2.2.10"

# bundler --version 1.17.1 compatível com ruby 2.2.x

#RUN bash -l -c 'rvm --default use ruby-2.2.10' && \
#    bash -l -c 'gem install bundler --version 1.17.1 --no-rdoc --no-ri' && \
#    bash -l -c 'bundle config --global jobs "$(($(getconf _NPROCESSORS_ONLN)*2))"' && \
#    bash -l -c 'bundle config --global retry 2' && \
#    bash -l -c "RAILS_ENV=${RAILS_ENV} bundle install --without development test --with production"

RUN bash -l -c 'rvm --default use ruby-2.2.10'
RUN bash -l -c 'RAILS_ENV=${RAILS_ENV} gem install bundler --version 1.17.1 --no-rdoc --no-ri'
RUN bash -l -c 'RAILS_ENV=${RAILS_ENV} bundle config --global jobs "$(($(getconf _NPROCESSORS_ONLN)*2))"'
RUN bash -l -c 'RAILS_ENV=${RAILS_ENV} bundle config --global retry 2'
#RUN bash -l -c "RAILS_ENV=${RAILS_ENV} bundle install --without development test --with production"
RUN bash -l -c "RAILS_ENV=${RAILS_ENV} bundle install"
RUN bash -l -c "RAILS_ENV=${RAILS_ENV} bundle install --without development test --with production"
RUN bash -l -c "RAILS_ENV=${RAILS_ENV} bundle exec rake assets:precompile"

# RAILS_ENV=${RAILS_ENV} bundle exec rails s -p 3000 -b 0.0.0.0

# which passenger-config
# /usr/bin/passenger-config
# --ruby-command
# /usr/bin/passenger-config --ruby-command

VOLUME [ "${APP_DIR}/config"]
#VOLUME [ "${APP_DIR}/shared/uploads"]
#VOLUME [ "${APP_DIR}/shared/bundle"]
#VOLUME [ "${APP_DIR}/shared/assets"]

USER root

#RUN chmod -R 777 $GEM_HOME

#RUN /bin/bash -l -c 'chown -R app:app  ${APP_HOME}'


EXPOSE $RACK_PORT
EXPOSE 80
EXPOSE 443

#mkdir -p /home/deploy/homologacao-tcc.unasus.ufsc.br/releases/20181101055726 /home/deploy/homologacao-tcc.unasus.ufsc.br/releases/20181101055726/tmp /home/deploy/homologacao-tcc.unasus.ufsc.br/releases/20181101055726/vendor /home/deploy/homologacao-tcc.unasu…
#rm -rf /home/deploy/homologacao-tcc.unasus.ufsc.br/releases/20181101055726/log
#ln -s /home/deploy/homologacao-tcc.unasus.ufsc.br/shared/log /home/deploy/homologacao-tcc.unasus.ufsc.br/releases/20181101055726/log
#ln -s /home/deploy/homologacao-tcc.unasus.ufsc.br/shared/tmp/pids /home/deploy/homologacao-tcc.unasus.ufsc.br/releases/20181101055726/tmp/pids
#ln -s /home/deploy/homologacao-tcc.unasus.ufsc.br/shared/tmp/cache /home/deploy/homologacao-tcc.unasus.ufsc.br/releases/20181101055726/tmp/cache
#ln -s /home/deploy/homologacao-tcc.unasus.ufsc.br/shared/tmp/sockets /home/deploy/homologacao-tcc.unasus.ufsc.br/releases/20181101055726/tmp/sockets
