class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items
  has_many :invoices
  has_many :customers, through: :invoices
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices

  def self.handle_pagination(per_page=20, page=1)
    offset = 0 if page < 2 
    offset = per_page * (page - 1) if page >= 2
    per_page = 20 if per_page > 20
    all.limit(per_page).offset(offset)
  end
end