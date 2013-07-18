SistemaTcc::Application.routes.draw do

  root to: 'lti#establish_connection'
  match 'lti' => 'lti#establish_connection'
  match 'access_denied' => 'lti#access_denied'

  match 'instructor_admin_tccs' => 'instructor_admin#index'

  # Ajax
  match "ajax/build" => "ajax#build"

  # Web Service
  match 'reportingservice' => 'service#report', :defaults => { :format => 'json' }

  #TCC routes
  get "tcc" => 'tccs#show', as: 'show_tcc'
  put "tcc" => 'tccs#save', as: 'save_tcc'

  get "abstract" => "abstracts#show", as: 'show_abstract'
  match "abstract" => "abstracts#save", as: 'save_abstract', :via => [:post, :put]

  get "presentation" => "presentations#show", as: 'show_presentation'
  match "presentation" => "presentations#save", as: 'save_presentation', :via => [:post, :put]

  get "final_considerations" => "final_considerations#show", as: 'show_final_considerations'
  match "final_considerations" => "final_considerations#save", as: 'save_final_considerations', :via => [:post, :put]

  get "hubs/:position" => "hubs#show", as: 'show_hubs'
  match "hubs/:position" => "hubs#save", as: 'save_hubs', :via => [:post, :put]
  match "hubs" => "hubs#update_state", as: 'update_state_hubs', :via => [:post, :put]

  # Resources
  resources :bibliographies
  resources :general_refs
  resources :book_refs
  resources :book_cap_refs
  resources :article_refs
  resources :internet_refs
  resources :legislative_refs

end
