SistemaTcc::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  root to: 'lti#establish_connection', via: [:get, :post]
  match 'lti' => 'lti#establish_connection', via: [:get, :post]
  get 'access_denied' => 'lti#access_denied'

  get 'instructor_admin' => 'instructor_admin#index'

  # Autocomplete routes
  get 'instructor_admin/autocomplete_tcc_name'
  get 'tutor/autocomplete_tcc_name'
  get 'orientador/autocomplete_tcc_name'
  get 'compound_names_autocomplete_name' => 'compound_names#autocomplete_compound_name_name'

  # Ajax
  match 'ajax/build' => 'ajax#build', via: [:get, :post]

  # Web Service
  match 'reportingservice' => 'service#report', :defaults => {:format => 'json'}, via: [:get, :post]
  match 'reportingservice_tcc' => 'service#report_tcc', :defaults => {:format => 'json'}, via: [:get, :post]
  match 'tcc_definition_service' => 'service#tcc_definition', :defaults => {:format => 'json'}, via: [:get, :post]
  get 'ping' => 'service#ping'

  resources :chapter_comments

  # TCC routes
  scope "/(user/:moodle_user)" do
    resource :tcc, only: [:show, :update] do
      member do
        get 'preview'
        get 'generate', defaults: {format: 'pdf'}
        match 'evaluate' => 'tccs#evaluate', as: 'evaluate', via: [:post, :patch]
      end
    end

    resource :abstracts, only: [:edit, :create, :update]

    # Chapters
    get 'chapters/:position' => 'chapters#edit', as: 'edit_chapters'
    match 'chapters/:position' => 'chapters#save', as: 'save_chapters', via: [:pos, :patch, :put]
    match 'chapters/:position/import' => 'chapters#import', as: 'import_chapters', via: [:get]
    match 'chapters/:position/import' => 'chapters#execute_import', as: 'execute_import_chapters', via: [:post]

    # Resources
    resources :bibliographies
    resources :book_refs
    resources :book_cap_refs
    resources :article_refs
    resources :internet_refs
    resources :legislative_refs
    resources :thesis_refs
    resources :compound_names

    # FIXME: generalizar controller abaixo
    resources :orientador
  end

end
