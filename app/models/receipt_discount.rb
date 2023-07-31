class ReceiptDiscount < ApplicationRecord
  belongs_to :receipt
  belongs_to :receipt_category

  validates :comment, presence: true
  validates :discount, presence: true
  validates :receipt_category_id, presence: true
end
