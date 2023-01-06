class ReceiptDiscountsController < ApplicationController
  def show
    @receipt_discount = ReceiptDiscount.find(params[:id])
  end

  def new
    @receipt_discount = ReceiptDiscount.new
  end

  def create
    @receipt = Receipt.find(params[:id])
    @receipt_discount = @receipt.receipt_discounts.create(receipt_discount_params)
    redirect_to receipts_path(@receipt)
  end

  private

  def receipt_discount_params
    params.require(:receipt_detail).permit(:comment, :discount)
  end
end
