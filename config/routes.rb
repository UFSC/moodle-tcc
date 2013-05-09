SistemaTcc::Application.routes.draw do

  root to: 'lti#establish_connection'
  match 'lti' => 'lti#establish_connection'
  match 'access_denied' => 'lti#access_denied'

  match 'instructor_admin_tccs' => 'instructor_admin#index'

  # Ajax
  match "ajax/build" => "ajax#build"

  # Resources
  resources :tccs
  resources :bibliographies
  resources :general_refs

end
