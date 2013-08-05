Adherent::Engine.routes.draw do
  
  resources :coords


  resources :members do
    resource :coord
  end

  root :to=>'members#index'
end
