require 'rails_helper'

RSpec.describe Invoice do
  describe 'relationships' do
    it { should belong_to :customer }
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many :transactions }
    it { should have_many(:items).through(:invoice_items) }
  end
  describe 'class methods' do
    it '#get_unshipped_revenues' do
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)
      item_1 = create(:item, merchant: merchant_1)
      item_2 = create(:item, merchant: merchant_2)
      customer_1 = create(:customer)
      customer_2 = create(:customer)
      invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1, status: "packaged")
      invoice_2 = create(:invoice, merchant: merchant_2, customer: customer_2, status: "shipped")
      transaction_1 = create(:transaction, invoice: invoice_1, result: "success")
      transaction_2 = create(:transaction, invoice: invoice_2, result: "success")
      invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 99, unit_price: 5)
      invoice_item_2 = create(:invoice_item, invoice: invoice_2, item: item_2, quantity: 100, unit_price: 2)
      invoice_item_3 = create(:invoice_item, invoice: invoice_2, item: item_2, quantity: 1, unit_price: 2)

      expected_potential_revenue = 495.00
      require 'pry'; binding.pry
      expect(Invoice.get_unshipped_revenues(2).first.potential_revenue).to eq(expected_potential_revenue)
    end
  end
end