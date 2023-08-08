module ReceiptCategoriesHelper

  def id_from_name(name)
    ReceiptCategory.where(:name => name).collect(&:id)[0]
  end
end
