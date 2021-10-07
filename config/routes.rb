Rails.application.routes.draw do
  resources :users, only: [:index, :update, :destory]
  devise_for :users, path: "accounts", controllers: {
                       registrations: "users/registrations",
                       invitations: "users/invitations",
                     }
  root "sakes#index"
  resources :sakes do
    get :elasticsearch, on: :collection
  end
  get "/elasticsearch" => "elasticsearch#index", as: "elasticsearch"

  mount LetterOpenerWeb::Engine, at: "/letter_opener" unless Rails.env.production?
end
