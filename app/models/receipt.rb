class Receipt < ApplicationRecord
  has_many :receipt_details, inverse_of: :receipt, dependent: :delete_all
  has_many :receipt_prices, inverse_of: :receipt, dependent: :delete_all
  has_many :receipt_discounts, inverse_of: :receipt, dependent: :delete_all
  has_many :accounts, through: :receipt_prices

  validates :date, presence: true
  validates :is_income, presence: false
  validates :comment, presence: true
  validates :location, presence: false
  validates :store, presence: false

  # Ensure at least one associated record for prices & details
  validates :receipt_prices, presence: true
  validates :receipt_details, presence: true

  accepts_nested_attributes_for :receipt_details, allow_destroy: true#, reject_if: lambda {|attributes| attributes['pa_word'].blank?}
  accepts_nested_attributes_for :receipt_prices, allow_destroy: true
  accepts_nested_attributes_for :receipt_discounts, allow_destroy: true

  validates_associated :receipt_prices

  validate :total_equals_details_prices_and_discounts
  validate :accounts_uniqueness

  before_save :normalize_blank_values

  def normalize_blank_values
    attributes.each do |column, _|
      self[column].present? || self[column] = nil if column.in? %w[store location]
    end
  end

  def total_equals_details_prices_and_discounts
    # Check that every price is valid for both list
    return unless receipt_prices.map(&:price).map(&:present?).all?
    return unless receipt_details.map(&:price).map(&:present?).all?

    valid_receipt_prices = receipt_prices.to_a.select { |r_price| not r_price._destroy.present?}
    valid_receipt_details = receipt_details.to_a.select { |r_detail| not r_detail._destroy.present?}
    valid_receipt_discounts = receipt_discounts.to_a.select { |r_detail| not r_detail._destroy.present?}

    # For details, map price and quantity column and perform the multiplication
    price_to_quantity = valid_receipt_details.map(&:price).zip(valid_receipt_details.map(&:quantity)).map { |p, q| p * q }
    # Sum everything
    details_total = (price_to_quantity.sum).round(2)
    prices_total = (valid_receipt_prices.map(&:price).sum).round(2)
    # Set discount total to 0 if no discounts are present
    discounts_total = valid_receipt_discounts.present? ? (valid_receipt_discounts.map(&:discount).sum).round(2) : 0

    if (details_total - discounts_total).round(2) != prices_total
      self.errors.add(
        :base,
        "Totals do not match (Details : #{details_total}, Discounts : #{discounts_total}, Accounts : #{prices_total})"
      )
    end
  end

  def accounts_uniqueness
    valid_receipt_prices = receipt_prices.to_a.select { |r_price| not r_price._destroy.present?}
    accounts_id = valid_receipt_prices.map(&:account_id)
    unique_accounts_id = accounts_id.uniq
    return unless unique_accounts_id.size != accounts_id.size

    errors.add(:base, 'Some accounts are referenced more than once.')
  end

  def receipt_details_subtotal
    receipt_details.pluck(:price, :quantity).map { |p, q| p * q }.sum
  end
end
