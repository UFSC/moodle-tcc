require 'sidekiq/web'

Sidekiq::Web.session_secret = Rails.application.secrets[:secret_key_base]

class AuthConstraint

  def self.admin?(request)
    session = ActiveRecord::SessionStore::Session.find_by_session_id(request.cookies['_moodle_tcc'])
    return false if session.blank?
    message = session['data']
    obj = Marshal.load(Base64.decode64(message))

    ret_isAdmin = ( obj['lti_launch_params']['roles'].include?(Authentication::Roles.administrator) ||
      obj['lti_launch_params']['roles'].include?(Authentication::Roles.coordenador_avea) ||
        obj['lti_launch_params']['roles'].include?(Authentication::Roles.coordenador_curso)
    )
    return ret_isAdmin
  end
end

Rails.application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  root to: 'lti#establish_connection', via: [:get, :post]
  match 'lti' => 'lti#establish_connection', via: [:get, :post]
  get 'access_denied' => 'lti#access_denied'

  get 'config' => 'config#index', as: 'config'

  get 'instructor_admin' => 'instructor_admin#index'
  get 'instructor_admin_navbar' => 'instructor_admin#navbar'

  # match '/internal_institutions' => 'internal_institutions#index', via: [:get], as: 'internal_institutions'
  # match '/internal_institutions' => 'internal_institutions#create',via: [:post]
  # match '/internal_institutions/new' => 'internal_institutions#new', via: [:get], as: 'new_internal_institution'
  # match '/internal_institutions/:id/edit' => 'internal_institutions#edit',via: [:get, :post, :patch], as: 'edit_internal_institution'
  # match '/internal_institutions/:id' => 'internal_institutions#update',via: [:put, :patch],as: 'update_internal_institution'
  # match '/internal_institutions/:id' => 'internal_institutions#destroy',via: [:delete], as: 'internal_institution'

  resources :internal_institutions
  resources :internal_courses

  resources :tcc_definitions, only: [:index, :edit, :update]

  get   'compound_names' => 'compound_names#index'
  match 'compound_names' => 'compound_names#create',via: [:post]
  get   'new_compound_name' => 'compound_names#new'
  match '/compound_names/:id/edit' => 'compound_names#edit',via: [:get, :post, :patch], as: 'edit_compound_name'
  get   '/compound_names/:id' => 'compound_names#edit',as: 'show_compound_name'
  match '/compound_names/:id' => 'compound_names#update',via: [:put, :patch],as: 'update_compound_name'
  match '/compound_names/:id' => 'compound_names#destroy',via: [:delete],as: 'delete_compound_name'

  # Autocomplete routes
  get 'instructor_admin/autocomplete_tcc_name'
  get 'compound_names_autocomplete_name' => 'compound_names#autocomplete_compound_name_name'
  get 'internal_courses_autocomplete_name' => 'internal_courses#autocomplete_internal_course_course_name'
  get 'internal_institutions_autocomplete_name' => 'internal_institutions#autocomplete_internal_institution_institution_name'

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
    mount Sidekiq::Web, at: '/admin/sidekiq', as: :sidekiq_web
    # mount Sidekiq::Web => '/admin/sidekiq'
  end

  # TCC routes
  scope "/(user/:moodle_user)" do
    resource :tcc, only: [:show, :update] do
      member do
        get 'preview'
        get 'generate', defaults: {format: 'pdf'}
        get 'edit_grade' => 'tccs#edit_grade', as: 'edit_grade', :defaults => {:format => 'js'}
        match 'evaluate' => 'tccs#evaluate', as: 'evaluate', via: [:post, :patch]
        get 'open_pdf', defaults: {format: 'pdf'}
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
