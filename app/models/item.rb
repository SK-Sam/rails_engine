class Item < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :description
  validates :unit_price, presence: true
  
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  def self.find_by_args(min_price, max_price, name)
    return [] if min_price == nil && max_price == nil && (name == nil || name == "")
    min_price = 0 if min_price == nil
    max_price = Float::MAX if max_price == nil
    name = "" if name == nil

    where(
      'unit_price <= (?) AND unit_price >= (?) AND LOWER(name) LIKE (?)',
     "#{max_price.to_f}","#{min_price.to_f}", "%#{name.downcase}%"
    )
  end
end