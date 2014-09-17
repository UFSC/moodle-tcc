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

  # TCC routes
  scope "/(user/:moodle_user)" do
    get "tcc" => 'tccs#show', as: 'show_tcc'
    put "tcc" => 'tccs#save', as: 'save_tcc'
    get "/tcc/preview" => "tccs#preview_tcc", as: 'preview_tcc'
    get "/tcc/generate", to: 'tccs#show_pdf', as: 'generate_tcc', defaults: {format: 'pdf'}
    get "showreferences" => 'tccs#show_references', as: 'show_references'

    resource :abstracts do
      member do
        post 'update_state' => 'abstracts#update_state'
      end
    end

    resource :presentations do
      member do
        post 'update_state' => 'presentations#update_state'
      end
    end

    resource :final_considerations do
      member do
        post 'update_state' => 'final_considerations#update_state'
      end
    end

    # Chapters
    get "chapters/:position" => "chapters#show", as: 'show_chapters'
    match "chapters/:position" => "chapters#save", as: 'save_chapters', :via => [:pos, :patch, :put]

    # Resources
    resources :bibliographies
    resources :general_refs
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
