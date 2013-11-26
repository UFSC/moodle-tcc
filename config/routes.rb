SistemaTcc::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  root to: 'lti#establish_connection'
  match 'lti' => 'lti#establish_connection'
  match 'access_denied' => 'lti#access_denied'

  match 'instructor_admin' => 'instructor_admin#index'

  # Ajax
  match "ajax/build" => "ajax#build"

  # Web Service
  match 'reportingservice' => 'service#report', :defaults => {:format => 'json'}
  match 'tcc_definition_service' => 'service#tcc_definition', :defaults => {:format => 'json'}

  # TCC routes
  get "tcc/(:moodle_user)" => 'tccs#show', as: 'show_tcc'
  put "tcc" => 'tccs#save', as: 'save_tcc'
  get "/tccs/:moodle_user/preview" => "tccs#preview_tcc", as: 'preview_tcc'
  match '/tccs/:tcc_id/evaluate' => 'tccs#evaluate', :as => 'evaluate_tcc'
  get "/tccs/:moodle_user/generate.:format" => 'tccs#show_pdf', as: 'generate_tcc', :defaults => {:format => 'pdf'}
  get "showreferences" => 'tccs#show_references', as: 'show_references'

  # Abstracts
  get "abstract" => "abstracts#show", as: 'show_abstract'
  match "abstract" => "abstracts#save", as: 'save_abstract', :via => [:post, :put]
  match "abstracts" => "abstracts#update_state", as: 'update_state_abstracts', :via => [:post, :put]

  # Presentations
  get "presentation" => "presentations#show", as: 'show_presentation'
  match "presentation" => "presentations#save", as: 'save_presentation', :via => [:post, :put]
  match "presentations" => "presentations#update_state", as: 'update_state_presentations', :via => [:post, :put]

  # Final Considerations
  get "final_considerations" => "final_considerations#show", as: 'show_final_considerations'
  match "final_considerations" => "final_considerations#save", as: 'save_final_considerations', :via => [:post, :put]
  match "final_considerations" => "final_considerations#update_state", as: 'update_state_final_considerations', :via => [:post, :put]

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
  resources :orientador
  resources :tutor

end
