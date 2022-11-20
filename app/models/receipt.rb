class Receipt < ApplicationRecord
  has_many :receipt_details, inverse_of: :receipt, dependent: :destroy
  has_many :receipt_prices, inverse_of: :receipt, dependent: :destroy
  has_many :accounts, through: :receipt_prices

  validates :date, presence: true
  validates :is_income, presence: false
  validates :comment, presence: true

  # Ensure at least one associated record for prices & details
  validates :receipt_prices, presence: true
  validates :receipt_details, presence: true

  accepts_nested_attributes_for :receipt_details, allow_destroy: true#, reject_if: lambda {|attributes| attributes['pa_word'].blank?}
  accepts_nested_attributes_for :receipt_prices, allow_destroy: true

  validates_associated :receipt_prices

  validate :total_equals_details_prices

  def total_equals_details_prices
    return if receipt_details.map(&:price).blank?
    return if receipt_prices.map(&:price).blank?

    details_total = receipt_details.map(&:price).sum
    prices_total = receipt_prices.map(&:price).sum
    if details_total != prices_total
      errors.add(:base, "Totals do not match (Details : #{details_total}, Accounts : #{prices_total})")
    end
  end
end
