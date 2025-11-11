Rails.application.routes.draw do
  root "companies#index"

  resources :companies, only: [:index] do
    collection do
      get :search
    end
  end

  namespace :admin do
    get 'imports/new'
    get 'imports/create'
    resources :companies, only: [:new, :create], controller: "companies"
  end
end