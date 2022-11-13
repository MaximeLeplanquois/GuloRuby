class Receipt < ApplicationRecord
  has_many :receipt_details, inverse_of: :receipt, dependent: :destroy

  validates :date, presence: true
  validates :is_income, presence: false
  validates :comment, presence: true

  accepts_nested_attributes_for :receipt_details, allow_destroy: true#, reject_if: lambda {|attributes| attributes['pa_word'].blank?}
end
