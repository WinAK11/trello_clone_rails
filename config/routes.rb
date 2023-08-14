Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get "/users/sign_out" => "devise/sessions#destroy"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
  get "dashboard", to: "dashboard#index"

  resources :boards do
    resources :lists
    resources :board_users
  end

  resources :items do
    resources :item_members
  end

  resources :lists do
    resources :items
  end

  namespace :api do
    resources :boards do
      resources :lists, only: :index, controller: "lists"
      resources :list_positions, only: [:index, :update], controller: "list_positions"
    end
    put "item_positions", to: "item_positions#update"
    resources :items, only: :show
  end
end
