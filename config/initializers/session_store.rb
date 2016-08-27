# Be sure to restart your server when you modify this file.

# Rails.application.config.session_store :cookie_store, key: '_sistema-tcc_session'

ActiveRecord::SessionStore::Session.attr_accessible :data, :session_id

# Rails.application.config.session_store :active_record_store, :key => '_session_id'
# https://github.com/mperham/sidekiq/issues/2730
# Rails + Sidekiq::Web + wildcard domain session = confliciting cookies

#Rails.application.config.session_store :active_record_store, :key => '_session_id', domain: :all
Rails.application.config.session_store :active_record_store, domain: :all
