module ReceiptsHelper

  def total_sum_per_category
    Receipt.joins(:receipt_details => :receipt_category)
           .where('receipts.is_income is FALSE')
           .group('receipt_categories.name')
           .sum('receipt_details.price * receipt_details.quantity')
  end

  def total_discount_per_category
    ReceiptDiscount.joins(:receipt, :receipt_category)
                   .where('receipts.is_income is FALSE')
                   .group('receipt_categories.name')
                   .sum('receipt_discounts.discount')
  end

  def total_per_date_and_category
    total_cat_date = Receipt.joins(:receipt_details => :receipt_category)
                            .where('receipts.is_income is FALSE')
                            .group('receipt_categories.name, strftime("%m-%Y", receipts.date)')
                            .select("receipt_categories.name as 'r_name', receipts.date as 'r_date', sum(receipt_details.price * receipt_details.quantity) as 'total'")
    total_cat_discount_date = ReceiptDiscount.joins(:receipt, :receipt_category)
                                             .where('receipts.is_income is FALSE').group('receipt_categories.name, strftime("%m-%Y", receipts.date)')
                                             .select("receipt_categories.name as 'r_name', receipts.date as 'r_date', sum(receipt_discounts.discount) as 'total'")
    total_cat_date.each do |total|
      corr_disc = total_cat_discount_date.filter_map { |disc| disc[:total] if Date.parse(disc[:r_date]).strftime('%B %Y') == Date.parse(total[:r_date]).strftime('%B %Y') and disc[:r_name] == total[:r_name]}
      total[:total] = total[:total] - (corr_disc.empty? ? 0 : corr_disc[0])
    end
  end
end
