class ReceiptsController < ApplicationController
  def index
    @receipts = Receipt.all.includes(:receipt_details).order(date: :desc)
  end

  def show
    @receipt = Receipt.find(params[:id])
  end

  def new
    @receipt = Receipt.new(receipt_details: [ReceiptDetail.new],
                           receipt_prices: [ReceiptPrice.new])
  end

  def search_by_date
    if params[:query_month]
      month = Receipt.sanitize_sql_like(params[:query_month].rjust(2,'0'))
      year = Receipt.sanitize_sql_like(params[:query_year])
      @receipts = Receipt.all.where("strftime('%m-%Y', date) = ? ", "#{month}-#{year}").order(date: :asc)
      @month = Date::MONTHNAMES[params[:query_month].to_i]
      @year = year
      render 'receipts/search_by_date'
    end
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

  private

  def receipt_params
    params.require(:receipt).permit(:date, :comment, :is_income, :location, :store,
                                    receipt_details_attributes: [:id, :name, :price, :quantity,
                                                                 :receipt_category_id, '_destroy'],
                                    receipt_prices_attributes: [:id, :receipt_id, :account_id, :price, '_destroy'],
                                    receipt_discounts_attributes: [:id, :comment, :discount, '_destroy']
    )
  end
end
