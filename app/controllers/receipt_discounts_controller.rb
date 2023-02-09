class ReceiptDiscountsController < ApplicationController
  def show
    @receipt_discount = ReceiptDiscount.find(params[:id])
  end

  def create
    @receipt = Receipt.new(receipt_discounts: [ReceiptDiscount.new])
  end

  def destroy
    @receipt = Receipt.new(receipt_discounts: [ReceiptDiscount.new])
  end

  private

  def receipt_discount_params
    params.require(:receipt_discounts_attributes).permit(:comment, :discount)
  end
end
