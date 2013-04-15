SistemaTcc::Application.routes.draw do

  root :to => 'tccs#index'
  resources :tccs
  match "instructor_admin" => "instructor_admin#index"

end
