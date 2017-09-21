Rails.application.routes.draw do
  root 'users#index'
  
  resources :users

  # Ресурс вопросов (кроме экшенов :show, :new, :index)
  resources :questions, except: [:show, :new, :index]

  # Ресурс сессий (только три экшена :new, :create, :destroy)
  resource :session, only: [:new, :create, :destroy]
end
