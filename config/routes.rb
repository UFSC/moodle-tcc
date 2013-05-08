SistemaTcc::Application.routes.draw do

  get "general_refs/new"

  get "bibliographies_controller/index"

  root :to => 'tccs#index'
  resources :tccs
  resources :bibliographies
  resources :general_refs
  match "instructor_admin_tccs" => "instructor_admin#index"
  match "ajax/build" => "ajax#build"


end
