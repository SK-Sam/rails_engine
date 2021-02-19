class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items
  has_many :invoices
  has_many :customers, through: :invoices
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices

  def self.find_by_name_alphabetical(name)
    where('LOWER(name) LIKE ?', "%#{name.downcase}%").order(name: :asc).first
  end

  def self.most_revenue(qty)
    return "Error" if qty == nil || qty <= "0"
    joins(invoices: [:transactions, :invoice_items])
    .select("merchants.*, invoice_items.quantity * invoice_items.unit_price AS revenue")
    .where("transactions.result = ?", "success")
    .order("revenue DESC")
    .limit(qty.to_i)
  end
end