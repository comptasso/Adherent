Adherent::Engine.routes.draw do
  
  

  
  

  resources :coords
  resources :payments, :controller=>:allpayments


  resources :members do
    resource :coord
    resources :adhesions
    resources :payments
  end
  
  resources :payments do
    resources :reglements
  end

  root :to=>'members#index'
end
