Adherent::Engine.routes.draw do
  
  

  
  resources :coords


  resources :members do
    resource :coord
    resources :adhesions
    resources :payments
  end

  root :to=>'members#index'
end
