SistemaTcc::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  root to: 'lti#establish_connection'
  match 'lti' => 'lti#establish_connection', via: [:get, :post]
  get 'access_denied' => 'lti#access_denied'

  get 'instructor_admin' => 'instructor_admin#index'

  # Autocomplete routes
  get 'instructor_admin/autocomplete_tcc_name'
  get 'tutor/autocomplete_tcc_name'
  get 'orientador/autocomplete_tcc_name'

  # Ajax
  match 'ajax/build' => 'ajax#build', via: [:get, :post]


  # Web Service
  match 'reportingservice' => 'service#report', :defaults => {:format => 'json'}, via: [:get, :post]
  match 'reportingservice_tcc' => 'service#report_tcc', :defaults => {:format => 'json'}, via: [:get, :post]
  match 'tcc_definition_service' => 'service#tcc_definition', :defaults => {:format => 'json'}, via: [:get, :post]
  get 'ping' => 'service#ping'

  # TCC routes
  get "tcc/(:moodle_user)" => 'tccs#show', as: 'show_tcc'
  put "tcc" => 'tccs#save', as: 'save_tcc'
  get "/tccs/:moodle_user/preview" => "tccs#preview_tcc", as: 'preview_tcc'
  match '/tccs/:tcc_id/evaluate' => 'tccs#evaluate', :as => 'evaluate_tcc', via: [:get, :post]
  get "/tccs/:moodle_user/generate.:format" => 'tccs#show_pdf', as: 'generate_tcc', :defaults => {:format => 'pdf'}
  get "showreferences" => 'tccs#show_references', as: 'show_references'

  # Abstracts
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

  # Hubs
  get "hubs/:position" => "hubs#show", as: 'show_hubs'
  match "hubs/:position" => "hubs#save", as: 'save_hubs', :via => [:post, :put]
  match "hubs" => "hubs#update_state", as: 'update_state_hubs', :via => [:post, :put]
  get "hubs/tcc/:position" => "hubs#show_tcc", as: 'show_hubs_tcc'

  # Resources
  resources :bibliographies
  resources :general_refs
  resources :book_refs
  resources :book_cap_refs
  resources :article_refs
  resources :internet_refs
  resources :legislative_refs
  resources :thesis_refs
  resources :orientador
  resources :tutor

end
