class Account < ApplicationRecord
  has_many :receipt_prices, inverse_of: :account, dependent: :destroy
  has_many :receipts, through: :receipt_prices
end
