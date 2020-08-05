Rails.application.routes.draw do
  root "sakes#index"
  resources :sakes do
    get :filter, on: :collection
  end
end
