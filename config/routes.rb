SistemaTcc::Application.routes.draw do

  root :to => 'tccs#index'
  resources :tccs
  match "instructor_admin_tccs" => "instructor_admin#index"

end
