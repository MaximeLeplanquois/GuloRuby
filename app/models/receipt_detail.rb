class ReceiptDetail < ApplicationRecord
  belongs_to :receipt
  belongs_to :receipt_category

  validates :name, presence: true
  validates :price, presence: true
  validates :quantity, presence: true
  validates :receipt_category_id, presence: true
end