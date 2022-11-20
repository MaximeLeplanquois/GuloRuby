class ReceiptPrice < ApplicationRecord
  belongs_to :receipt
  belongs_to :account

  validates :account_id, presence: true
  validates :price, presence: true
end
