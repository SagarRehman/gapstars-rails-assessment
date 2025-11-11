Rails.application.routes.draw do
  root "companies#index"

  resources :companies, only: [:index] do
    collection { get :search }
  end

  namespace :admin do
    resources :companies, only: [:new, :create], controller: "companies"
  end
end