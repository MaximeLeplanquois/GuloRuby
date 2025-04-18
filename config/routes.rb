Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'receipts#index'
  # Defines the root path route ("/")
  # root "articles#index"
  resources :receipts
  resources :receipts do
    post 'edit' => 'receipts#edit', as: :edit
  end

  resources :receipt_details, only: [], param: :index do
    member do
      delete '(:id)' => 'receipt_details#destroy', as: ''
      post '/' => 'receipt_details#create'
    end
  end
  resources :receipt_prices, only: [], param: :index do
    member do
      delete '(:id)' => 'receipt_prices#destroy', as: ''
      post '/' => 'receipt_prices#create'
    end
  end
  resources :receipt_discounts, only: [], param: :index do
    member do
      delete '(:id)' => 'receipt_discounts#destroy', as: ''
      post '/' => 'receipt_discounts#create'
    end
  end
  resources :accounts
  resources :receipt_categories

  get '/search', to: 'receipts#search_by_date'
  post '/search', to: 'receipts#search_by_date'

  get '/all_receipts', to: 'receipts#all_receipts'
  post '/all_receipts', to: 'receipts#all_receipts'
end
