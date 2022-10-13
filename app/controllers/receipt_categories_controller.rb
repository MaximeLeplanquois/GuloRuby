class ReceiptCategoriesController < ApplicationController
  def index
    @receipt_categories = ReceiptCategory.all
  end

  def show
    @receipt_category = ReceiptCategory.find(params[:id])
  end

  def new
    @receipt_category = ReceiptCategory.new
  end

  def create
    @receipt_category = ReceiptCategory.new(receipt_category_params)
    if @receipt_category.save
      redirect_to action: "index"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def receipt_category_params
    params.require(:receipt_category).permit(:name)
  end
end
