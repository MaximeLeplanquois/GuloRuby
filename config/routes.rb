Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'receipts#index'
  # Defines the root path route ("/")
  # root "articles#index"
  resources :receipts do
    post :add_detail, on: :collection
    post :add_price, on: :collection
    post :update_form, on: :collection
  end
  resources :accounts
  resources :receipt_categories
  # resources :receipt_details, only: [:show]
  resources :receipt_details
end
