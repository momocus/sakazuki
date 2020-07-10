Rails.application.routes.draw do
  resources :sakes do
    get :filter, on: :collection
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "sakes#index"
end
