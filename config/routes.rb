Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'receipts#index'
  # Defines the root path route ("/")
  # root "articles#index"
  resources :receipts
  resources :accounts
  resources :receipt_categories
end
