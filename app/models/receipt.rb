class Receipt < ApplicationRecord
  has_many :receipt_details, inverse_of: :receipt, dependent: :delete_all
  has_many :receipt_prices, inverse_of: :receipt, dependent: :delete_all
  has_many :receipt_discounts, inverse_of: :receipt, dependent: :delete_all
  has_many :accounts, through: :receipt_prices

  validates :date, presence: true
  validates :is_income, presence: false
  validates :comment, presence: true
  validates :location, presence: true

  # Ensure at least one associated record for prices & details
  validates :receipt_prices, presence: true
  validates :receipt_details, presence: true

  accepts_nested_attributes_for :receipt_details, allow_destroy: true#, reject_if: lambda {|attributes| attributes['pa_word'].blank?}
  accepts_nested_attributes_for :receipt_prices, allow_destroy: true
  accepts_nested_attributes_for :receipt_discounts, allow_destroy: true

  validates_associated :receipt_prices

  validate :total_equals_details_prices_and_discounts
  validate :accounts_uniqueness

  def total_equals_details_prices_and_discounts
    # Check that every price is valid for both list
    return unless receipt_prices.map(&:price).map(&:present?).all?
    return unless receipt_details.map(&:price).map(&:present?).all?

    # For details, map price and quantity column and perform the multiplication
    price_to_quantity = receipt_details.map(&:price).zip(receipt_details.map(&:quantity)).map { |p, q| p * q }
    # Sum everything
    details_total = price_to_quantity.sum
    prices_total = receipt_prices.map(&:price).sum
    # Set discount total to 0 if no discounts are present
    discounts_total = receipt_discounts.present? ? receipt_discounts.map(&:discount).sum : 0

    if details_total - discounts_total != prices_total
      errors.add(
        :prices_mismatch,
        "Totals do not match (Details : #{details_total}, Discounts : #{discounts_total}, Accounts : #{prices_total})"
      )
    end
  end

  def accounts_uniqueness
    accounts_id = receipt_prices.map(&:account_id)
    unique_accounts_id = accounts_id.uniq
    return unless unique_accounts_id.size != accounts_id.size
    errors.add(:duplicate_account, "Some accounts are referenced more than once.")
  end

  def receipt_details_subtotal
    receipt_details.pluck(:price, :quantity).map { |p, q| p * q }.sum
  end
end
