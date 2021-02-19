class Invoice < ApplicationRecord

  belongs_to :merchant
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  def self.get_unshipped_revenues(qty=10)
    return "Error" if qty == nil || qty.to_i <= 0 || qty.to_s.count("a-zA-Z") > 0
    joins(:invoice_items, :transactions)
    .select("invoices.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    .where("invoices.status = ? AND transactions.result = ?", "packaged", "success")
    .group("invoices.id")
    .order("revenue DESC")
    .limit(qty.to_i)
  end
end