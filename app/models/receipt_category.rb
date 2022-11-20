class ReceiptCategory < ApplicationRecord
  has_many :receipt_details, inverse_of: :receipt_category
end
