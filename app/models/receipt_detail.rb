class ReceiptDetail < ApplicationRecord
  belongs_to :receipt

  validates :name, presence: true
  validates :price, presence: true
  validates :quantity, presence: true
end