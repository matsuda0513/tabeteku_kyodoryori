Rails.application.routes.draw do
  root 'pages#home'
  resources :foods, only: [:index, :show] do
    collection do
      get 'search'
    end
  end
end