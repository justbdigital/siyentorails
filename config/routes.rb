Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'devise/user_omniauth_callbacks' }
  get 'home/index'
  post 'home/filter'

  root 'home#index'
end
