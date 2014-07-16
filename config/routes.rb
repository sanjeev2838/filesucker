Filesucker::Application.routes.draw do
  resources :folders

  resources :assets
  match "assets/get/:id" => "assets#get", :as => "download" ,via: [:get]

  match "browse/:folder_id" => "home#browse", :as => "browse" , via: [:get]

  match "browse/:folder_id/new_folder" => "folders#new", :as => "new_sub_folder" , via: [:get]
  match "browse/:folder_id/new_file" => "assets#new", :as => "new_sub_file", via:[:get]

  match "browse/:folder_id/rename" => "folders#edit", :as => "rename_folder" , via:[:get]

  devise_for :users
  get "home/index"
  root :to => "home#index"

end
