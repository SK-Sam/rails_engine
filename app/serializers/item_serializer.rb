class ItemSerializer
  include FastJsonapi::ObjectSerializer
  # belongs_to :merchant
  # has_many :invoice_items
  # has_many :invoices, through: :invoice_items
  # has_many :transactions, through: :invoices

  attributes :name, :description, :unit_price, :merchant_id
end
