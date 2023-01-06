class ReceiptDiscount < ApplicationRecord
  belongs_to :receipt

  validates :comment, presence: true
  validates :discount, presence: true
end
