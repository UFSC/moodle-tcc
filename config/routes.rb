SistemaTcc::Application.routes.draw do

  root :to => 'tcc#show'
  resources :tccs

end
