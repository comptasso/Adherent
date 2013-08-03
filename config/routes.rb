Adherent::Engine.routes.draw do
  resources :adherents

  root :to=>'adherents#index'
end
