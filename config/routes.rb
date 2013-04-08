SistemaTcc::Application.routes.draw do

  root :to => 'tccs#show'
  resources :tccs

end
