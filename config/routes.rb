Rails.application.routes.draw do
   devise_for :users, controllers: {
  omniauth_callbacks: "omniauth_callbacks"
}
  root 'users#index'

  resources :users, only: [:index, :edit, :update,:show]
  resources :books,only: [:index,:new]
  resources :book_shelves,only: [:create,:destroy] do
    resources :memos,only:[:index,:destroy]
  end
  get 'memos/index'
  post 'line/callback'
  post '/callback', to: 'webhook#callback'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
