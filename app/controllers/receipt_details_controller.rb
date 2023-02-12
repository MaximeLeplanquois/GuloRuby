class ReceiptDetailsController < ApplicationController

  def show
    @receipt_detail = ReceiptDetail.find(params[:id])
  end

  def create
    @receipt = Receipt.new(receipt_details: [ReceiptDetail.new])
  end

  def destroy
    details_count = 0
    params['receipt']['receipt_details_attributes'].each_value do |receipt_detail|
      details_count += (receipt_detail['_destroy'].nil? ? 1 : 0)
    end
    if details_count > 1
      @receipt = Receipt.new(receipt_details: [ReceiptDetail.new])
    else
      @receipt = Receipt.new
      error = 'Receipt need at least one detail.'
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(
            'receipt_details_error_messages',
            "<div>#{error}</div>"
          )
        end
        format.html { render 'receipts/new' }
      end
    end
    @receipt = Receipt.new(receipt_details: [ReceiptDetail.new])
  end

  private

  def receipt_detail_params
    params.require(:receipt_detail).permit(:name, :price, :quantity)
  end
end
