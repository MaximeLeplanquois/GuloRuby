class Receipt < ApplicationRecord
  has_many :receipt_details, inverse_of: :receipt, dependent: :destroy
  has_many :receipt_prices, inverse_of: :receipt, dependent: :destroy
  has_many :accounts, through: :receipt_prices

  validates :date, presence: true
  validates :is_income, presence: false
  validates :comment, presence: true

  accepts_nested_attributes_for :receipt_details, allow_destroy: true#, reject_if: lambda {|attributes| attributes['pa_word'].blank?}
  accepts_nested_attributes_for :receipt_prices, allow_destroy: true
end
