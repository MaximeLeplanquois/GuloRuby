class ReceiptDetailsController < ApplicationController

  def show
    @receipt_detail = ReceiptDetail.find(params[:id])
  end

  def create
    @receipt = Receipt.new(receipt_details: [ReceiptDetail.new])
  end

  def destroy
    details_count = params['receipt']['receipt_details_attributes'].keys.length
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
