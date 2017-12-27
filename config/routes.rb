Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root to: 'toppages#index'
  get 'show', to: 'toppages#show'
  post 'syntax', to: 'toppages#syntax'
end
