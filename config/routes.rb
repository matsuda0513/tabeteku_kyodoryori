Rails.application.routes.draw do
  root 'foods#index'
  get 'foods/show', to: 'foods#show'
end