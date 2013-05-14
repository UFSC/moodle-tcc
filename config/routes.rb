SistemaTcc::Application.routes.draw do

  root to: 'lti#establish_connection'
  match 'lti' => 'lti#establish_connection'
  match 'access_denied' => 'lti#access_denied'

  match 'instructor_admin_tccs' => 'instructor_admin#index'

  # Ajax
  match "ajax/build" => "ajax#build"

  # Resources
  #resources :tccs

  match "tcc/:tab" => 'tccs#show', as: 'tccs_tabs'
  match "tcc/:tab/:category" => 'tccs#show', as: 'tccs_hubs_tabs'
  resource :tcc

  resources :bibliographies
  resources :general_refs

end
