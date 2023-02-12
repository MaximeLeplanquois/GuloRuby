class ReceiptPricesController < ApplicationController

  def show
    @receipt_price = ReceiptPrice.find(params[:id])
  end

  def create
    accounts_count = 0
    params['receipt']['receipt_prices_attributes'].each_value do |receipt_price|
      accounts_count += (receipt_price['_destroy'].nil? ? 1 : 0)
    end
    if accounts_count < Account.count
      @receipt = Receipt.new(receipt_prices: [ReceiptPrice.new])
    else
      @receipt = Receipt.new
      error = 'Cannot add more accounts.'
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(
            'receipt_prices_error_messages',
            "<div>#{error}</div>"
          )
        end
        format.html { render 'receipts/new' }
      end
    end
  end

  def destroy
    # Check number of valid prices
    accounts_count = 0
    params['receipt']['receipt_prices_attributes'].each_value do |receipt_price|
      accounts_count += (receipt_price['_destroy'].nil? ? 1 : 0)
    end
    # If at least one price still present, proceed with removal of flagged prices
    if accounts_count > 1
      @receipt = Receipt.new(receipt_prices: [ReceiptPrice.new])
    else
      @receipt = Receipt.new
      error = 'Need at least one account.'
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(
            'receipt_prices_error_messages',
            "<div>#{error}</div>"
          )
        end
        format.html { render 'receipts/new' }
      end
    end
    @receipt = Receipt.new(receipt_prices: [ReceiptPrice.new])
  end

  private

  def receipt_price_params
    params.require(:receipt_prices_attributes).permit(:receipt_id, :account_id, :price, '_destroy')
  end
end

