Rails.application.routes.draw do
  devise_for :users
  root "sakes#index"
  resources :sakes do
    get :filter, on: :collection
  end
end
