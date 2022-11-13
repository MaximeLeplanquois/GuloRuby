class ReceiptPrice < ApplicationRecord
  belongs_to :receipt
  belongs_to :account
end
