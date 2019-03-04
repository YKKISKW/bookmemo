Rails.application.routes.draw do
  # get 'memos/index'
  # post 'line/callback'
  post '/callback', to: 'webhook#callback'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
