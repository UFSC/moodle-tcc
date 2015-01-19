require 'sidekiq/web'

class AuthConstraint
  def self.admin?(request)
    return true
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
  get 'new_compound_name' => 'compound_names#new',:defaults => {:format => 'js'}
  match '/compound_names/:id/edit' => 'compound_names#edit',via: [:get, :post, :patch], as: 'edit_compound_name',:defaults => {:format => 'js'}
  get '/compound_names/:id' => 'compound_names#edit',as: 'show_compound_name'
  match '/compound_names/:id' => 'compound_names#update',via: [:put, :patch],as: 'update_compound_name'
  match '/compound_names/:id' => 'compound_names#destroy',via: [:delete],as: 'delete_compound_name'

  # compound_names GET            (/user/:moodle_user)/compound_names(.:format)            compound_names#index
  # POST           (/user/:moodle_user)/compound_names(.:format)            compound_names#create
  # new_compound_name GET            (/user/:moodle_user)/compound_names/new(.:format)        compound_names#new
  # edit_compound_name GET            (/user/:moodle_user)/compound_names/:id/edit(.:format)   compound_names#edit
  # compound_name GET            (/user/:moodle_user)/compound_names/:id(.:format)        compound_names#show
  # PATCH          (/user/:moodle_user)/compound_names/:id(.:format)        compound_names#update
  # PUT            (/user/:moodle_user)/compound_names/:id(.:format)        compound_names#update
  # DELETE         (/user/:moodle_user)/compound_names/:id(.:format)        compound_names#destroy

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

    # sidekiq monitor
    #mount Sidekiq::Monitor::Engine => '/sidekiq'
    # constraints lambda {|request| AuthConstraint.admin?(request) } do
    #   mount Sidekiq::Monitor::Engine => '/sidekiq'
    # end

    # sidekiq monitor sinatra
    mount Sidekiq::Web, at: "/sidekiq"
  end

end
