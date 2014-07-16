Filesucker::Application.routes.draw do
  resources :folders

  resources :assets
  match "assets/get/:id" => "assets#get", :as => "download" ,via: [:get]

  devise_for :users
  get "home/index"
  root :to => "home#index"
end
