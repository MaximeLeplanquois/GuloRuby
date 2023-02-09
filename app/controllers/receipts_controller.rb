class ReceiptsController < ApplicationController
  def index
    @receipts = Receipt.all.includes(:receipt_details)
  end

  def show
    @receipt = Receipt.find(params[:id])
  end

  def new
    @receipt = Receipt.new(receipt_details: [ReceiptDetail.new],
                           receipt_prices: [ReceiptPrice.new])
  end

  def add_detail_edit
    @receipt = Receipt.find(params[:id])
    @receipt.attributes = receipt_params
    @receipt.receipt_details.build
    render :edit
  end

  def update_form
    @receipt = Receipt.new(receipt_params.merge({ id: params[:id] }))
    render :new
  end

  def add_price_edit
    @receipt = Receipt.find(params[:id])
    @receipt.attributes = receipt_params
    @receipt.receipt_prices.build
    render :edit
  end

  def add_discount_edit
    @receipt = Receipt.find(params[:id])
    @receipt.attributes = receipt_params
    @receipt.receipt_discounts.build
    render :edit
  end

  def create
    @receipt = Receipt.new(receipt_params)
    if @receipt.save
      redirect_to action: 'index'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def receipt_params
    params.require(:receipt).permit(:date, :comment, :is_income, :location, receipt_details_attributes: [
                                      :id, :name, :price, :quantity, :receipt_category_id, '_destroy'],
                                    receipt_prices_attributes: [:account_id, :price, '_destroy'],
                                    receipt_discounts_attributes: [:comment, :discount, '_destroy']
    )
  end
end
