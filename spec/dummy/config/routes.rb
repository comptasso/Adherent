Rails.application.routes.draw do

  resources :organisms


  mount Adherent::Engine => "/adherent"
  
  root :to=>'organisms#index'
end
