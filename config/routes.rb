SistemaTcc::Application.routes.draw do

  root to: 'lti#establish_connection'
  match 'lti' => 'lti#establish_connection'
  match 'access_denied' => 'lti#access_denied'

  match 'instructor_admin_tccs' => 'instructor_admin#index'

  # Ajax
  match "ajax/build" => "ajax#build"

  # Resources
  #resources :tccs

  match "tccs/:tab" => 'tccs#index', as: 'tccs_tabs'
  match "tccs/:tab/:category" => 'tccs#index', as: 'tccs_hubs_tabs'
  resources :tccs, :path => 'tccs'

  resources :bibliographies
  resources :general_refs

end
