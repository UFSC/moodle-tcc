SistemaTcc::Application.routes.draw do

  root :to => 'tccs#show'
  resources :tccs
  match "instructor_admin" => "instructor_admin#show"

end
