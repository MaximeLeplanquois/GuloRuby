class ReceiptsController < ApplicationController
  def index
    @receipts = Receipt.all.includes(:receipt_details)
  end

  def show
    @receipt = Receipt.find(params[:id])
  end

  def new
    @receipt = Receipt.new
    @receipt.receipt_details.build
    @receipt.receipt_prices.build
  end

  def add_detail
    @receipt = Receipt.new(receipt_params.merge({ id: params[:id] }))
    @receipt.receipt_details.build # add another detail
    render :new
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

  def add_price
    @receipt = Receipt.new(receipt_params.merge({ id: params[:id] }))
    if @receipt.receipt_prices.size < Account.count
      @receipt.receipt_prices.build # add another detail
      render :new
    else
      @no_more_accounts_msg = 'Cannot add more accounts.'
      render :new, status: :unprocessable_entity
    end
  end

  def add_price_edit
    @receipt = Receipt.find(params[:id])
    @receipt.attributes = receipt_params
    @receipt.receipt_prices.build
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
    params.require(:receipt).permit(:date, :comment, :is_income, receipt_details_attributes: [
                                      :id, :name, :price, :quantity, :receipt_category_id, '_destroy'],
                                    receipt_prices_attributes: [:account_id, :price, '_destroy']
    )
  end
end
