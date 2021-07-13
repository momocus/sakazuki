Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
  }
  root "sakes#index"
  resources :sakes do
    get :elasticsearch, on: :collection
  end
  get "/elasticsearch" => "elasticsearch#index", as: "elasticsearch"

  mount LetterOpenerWeb::Engine, at: "/letter_opener" unless Rails.env.production?
end
