Rails.application.routes.draw do
   devise_for :users, controllers: {
  omniauth_callbacks: "omniauth_callbacks"
}
  root 'users#index'

  resources :users, only: [:index, :edit, :update]
  resources :books, only: [:index, :new, :create,:show]
  # do
  #   resources :memos
  # end
  # get 'books/new'
  get 'memos/index'
  post 'line/callback'
  post '/callback', to: 'webhook#callback'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
