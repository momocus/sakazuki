Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
  }
  root "sakes#index"
  resources :sakes do
    get :elasticsearch, on: :collection
  end
  get "sakes/:id/show_photo" => "sakes#show_photo", as: "show_photo"

  mount LetterOpenerWeb::Engine, at: "/letter_opener" unless Rails.env.production?
end
