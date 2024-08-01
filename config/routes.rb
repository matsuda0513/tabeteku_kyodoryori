Rails.application.routes.draw do
  root 'pages#home'
  resources :foods, only: [:index, :show] do
    collection do
      get 'search'
    end
  end

  # 英語のトップページ
  get 'english', to: 'english_pages#home', as: 'english_home'
  # 英語の foods ルーティング
  resources :english_foods, only: [:index, :show] do
    collection do
      get 'search'
    end
  end
end
