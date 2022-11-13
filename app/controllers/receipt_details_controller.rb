class ReceiptDetailsController < ApplicationController
  def show
    @receipt_detail = ReceiptDetail.find(params[:id])
  end

  def new
    @receipt_detail = ReceiptDetail.new
  end

  def create
    @receipt = Receipt.find(params[:id])
    @receipt_detail = @receipt.receipt_details.create(receipt_detail_params)
    redirect_to receipts_path(@receipt)
  end

  private

  def receipt_detail_params
    params.require(:receipt_detail).permit(:name, :price, :quantity)
  end
end
