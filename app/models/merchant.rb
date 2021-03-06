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
    return "Error" if qty == nil || qty.to_i <= 0 || qty.to_s.count("a-zA-Z") > 0 || qty == ""
    joins(invoices: [:transactions, :invoice_items])
    .select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    .where("transactions.result = ?", "success")
    .group("merchants.id")
    .order("revenue DESC")
    .limit(qty.to_i)
  end

  def self.sold_most_items(qty=5)
    return "Error" if qty == nil || qty.to_i <= 0 || qty.to_s.count("a-zA-Z") > 0
    joins(invoices: [:transactions, :invoice_items])
    .select("merchants.*, SUM(invoice_items.quantity) AS count")
    .where("transactions.result = ?", "success")
    .group("merchants.id")
    .order("count DESC")
    .limit(qty.to_i)
  end

  def self.merchant_revenue(merchant_id)
    joins(invoices: [:transactions, :invoice_items])
    .select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    .where("transactions.result = ? AND invoices.merchant_id = ?", "success", merchant_id)
    .group("merchants.id")
    .first
  end
end