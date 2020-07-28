Rails.application.routes.draw do
  root "sakes#index"
  # get     "/signup",  to: "users#new" 新規ユーザー登録はできないようにする
  get     "/signin",  to: "sessions#new"
  post    "/signin",  to: "sessions#create"
  delete  "/signout", to: "sessions#destroy"
  resources :sakes do
    get :filter, on: :collection
  end
  resources :users
end
