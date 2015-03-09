require 'sidekiq/web'

class AuthConstraint

  def self.admin?(request)
    message = CGI.unescape(request.cookies['_sistema-tcc_session'])

    config = Rails.application.config

    secret_key_base = SECRET_FILE['secret_key_base']

    key_generator = ActiveSupport::KeyGenerator.new(
        secret_key_base, iterations: 1000
    )

    secret = key_generator.generate_key(
        config.action_dispatch.encrypted_cookie_salt
    )

    sign_secret = key_generator.generate_key(
        config.action_dispatch.encrypted_signed_cookie_salt
    )

    encryptor = ActiveSupport::MessageEncryptor.new(
        secret, sign_secret
    )

    obj = encryptor.decrypt_and_verify(message)

    ( obj['lti_launch_params']['roles'].include?(Authentication::Roles.administrator) ||
      obj['lti_launch_params']['roles'].include?(Authentication::Roles.coordenador_avea) ||
        obj['lti_launch_params']['roles'].include?(Authentication::Roles.coordenador_curso)
    )

  end

end

Rails.application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  root to: 'lti#establish_connection', via: [:get, :post]
  match 'lti' => 'lti#establish_connection', via: [:get, :post]
  get 'access_denied' => 'lti#access_denied'

  get 'instructor_admin' => 'instructor_admin#index'
  get 'instructor_admin_navbar' => 'instructor_admin#navbar'

  get 'compound_names' => 'compound_names#index'
  match 'compound_names' => 'compound_names#create',via: [:post]
  get 'new_compound_name' => 'compound_names#new'
  match '/compound_names/:id/edit' => 'compound_names#edit',via: [:get, :post, :patch], as: 'edit_compound_name'
  get '/compound_names/:id' => 'compound_names#edit',as: 'show_compound_name'
  match '/compound_names/:id' => 'compound_names#update',via: [:put, :patch],as: 'update_compound_name'
  match '/compound_names/:id' => 'compound_names#destroy',via: [:delete],as: 'delete_compound_name'

  # Autocomplete routes
  get 'instructor_admin/autocomplete_tcc_name'
  get 'tutor/autocomplete_tcc_name'
  get 'orientador/autocomplete_tcc_name'
  get 'compound_names_autocomplete_name' => 'compound_names#autocomplete_compound_name_name'

  # Ajax
  match 'ajax/build' => 'ajax#build', via: [:get, :post]

  # Web Service
  match 'reportingservice_tcc' => 'service#report_tcc', :defaults => {:format => 'json'}, via: [:get, :post]
  match 'tcc_definition_service' => 'service#tcc_definition', :defaults => {:format => 'json'}, via: [:get, :post]
  get 'ping' => 'service#ping'

  get 'batch_select' => 'batch_prints#index'
  match 'batch_print' => 'batch_prints#print', via: [:post]

  # sidekiq monitor
  #mount Sidekiq::Monitor::Engine => '/sidekiq'
  # constraints lambda {|request| AuthConstraint.admin?(request) } do
  #   mount Sidekiq::Monitor::Engine => '/sidekiq'
  # end

  # sidekiq monitor sinatra
  #mount Sidekiq::Web, at: '/sidekiq'

  constraints lambda {|request| AuthConstraint.admin?(request) } do
    #mount Sidekiq::Web, at: '/sidekiq'
    mount Sidekiq::Web => '/admin/sidekiq'
  end

  # TCC routes
  scope "/(user/:moodle_user)" do
    resource :tcc, only: [:show, :update] do
      member do
        get 'preview'
        get 'generate', defaults: {format: 'pdf'}
        get 'edit_grade' => 'tccs#edit_grade', as: 'edit_grade', :defaults => {:format => 'js'}
        match 'evaluate' => 'tccs#evaluate', as: 'evaluate', via: [:post, :patch]
      end
    end

    resource :abstracts, only: [:edit, :create, :update]

    # Chapters
    get 'chapters/:position' => 'chapters#edit', as: 'edit_chapters'
    match 'chapters/:position' => 'chapters#save', as: 'save_chapters', via: [:post, :patch, :put]
    match 'chapters/:position/import' => 'chapters#import', as: 'import_chapters', via: [:get]
    match 'chapters/:position/import' => 'chapters#execute_import', as: 'execute_import_chapters', via: [:post]
    match 'chapters/:position/empty' => 'chapters#empty', as: 'empty_chapters', via: [:get]

    # Resources
    resources :bibliographies
    resources :book_refs
    resources :book_cap_refs
    resources :article_refs
    resources :internet_refs
    resources :legislative_refs
    resources :thesis_refs
    #resources :compound_names

    # FIXME: generalizar controller abaixo
    resources :orientador

  end

end
