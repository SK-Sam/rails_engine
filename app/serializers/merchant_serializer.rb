class MerchantSerializer
  include FastJsonapi::ObjectSerializer
  has_many :items
  has_many :invoices
  has_many :customers, through: :invoices
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices
  
  attributes :name
end
