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

  def destroy
    @receipt = Receipt.find(params[:id])
    @receipt.destroy

    redirect_to root_path
  end

  def edit
    @receipt = Receipt.find(params[:id])
    render 'receipts/edit'
  end

  def update
    @receipt = Receipt.find(params[:id])
    if @receipt.update(receipt_params) && @receipt.valid?
      redirect_to @receipt
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(
            'receipt_errors',
            partial: 'common/errors',
            locals: { errors_list: @receipt.errors }
          )
        end
      end
    end
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
                                    receipt_prices_attributes: [:id, :receipt_id, :account_id, :price, '_destroy'],
                                    receipt_discounts_attributes: [:id, :comment, :discount, '_destroy']
    )
  end
end
