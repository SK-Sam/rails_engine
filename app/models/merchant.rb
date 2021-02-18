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
end