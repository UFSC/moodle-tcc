SistemaTcc::Application.routes.draw do

  root to: 'lti#establish_connection'
  resources :tccs

  match 'lti' => 'lti#establish_connection'
  match 'instructor_admin_tccs' => 'instructor_admin#index'
end