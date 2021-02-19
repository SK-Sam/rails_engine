require 'rails_helper'

RSpec.describe Merchant do
  describe 'relationships' do
    it { should have_many :items }
    it { should have_many :invoices }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:invoice_items).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end
  describe 'validations' do
    it { should validate_presence_of :name }
  end
  describe 'class methods' do
    it '#handle_pagination' do
      create_list(:merchant, 21)
      five_per_page = Merchant.handle_pagination(5)

      expect(five_per_page.count).to eq(5)

      page_two = Merchant.handle_pagination(20, 2)

      expect(page_two.count).to eq(1)
      expect(page_two.first).to eq(Merchant.all.last)

      default_args = Merchant.handle_pagination

      expect(default_args.count).to eq(20)

      over_limit_twenty = Merchant.handle_pagination(21)

      expect(over_limit_twenty.count).to eq(20)

      nil_handling = Merchant.handle_pagination(nil, nil)

      expect(nil_handling.count).to eq(20)
    end
    it '#find_by_name_alphabetical' do
      incorrect_merchant = create(:merchant, name: "Turing")
      correct_merchant = create(:merchant, name: "Ring World")

      expect(Merchant.find_by_name_alphabetical("ring")).to eq(correct_merchant)
      expect(Merchant.find_by_name_alphabetical("Ring")).to eq(correct_merchant)
    end
    it '#most_revenue' do
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)
      item_1 = create(:item, merchant: merchant_1)
      item_2 = create(:item, merchant: merchant_2)
      customer_1 = create(:customer)
      customer_2 = create(:customer)
      invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
      invoice_2 = create(:invoice, merchant: merchant_2, customer: customer_2)
      transaction_1 = create(:transaction, invoice: invoice_1, result: "success")
      transaction_2 = create(:transaction, invoice: invoice_2, result: "success")
      invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 100, unit_price: 5)
      invoice_item_2 = create(:invoice_item, invoice: invoice_2, item: item_2, quantity: 100, unit_price: 2)

      expect(Merchant.most_revenue(1)).to eq([merchant_1])
      expect(Merchant.most_revenue(2)).to eq([merchant_1, merchant_2])
      expect(Merchant.most_revenue(-1)).to eq("Error")
      expect(Merchant.most_revenue(0)).to eq("Error")
      expect(Merchant.most_revenue(nil)).to eq("Error")
    end
    it '#sold_most_items' do
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)
      item_1 = create(:item, merchant: merchant_1)
      item_2 = create(:item, merchant: merchant_2)
      customer_1 = create(:customer)
      customer_2 = create(:customer)
      invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
      invoice_2 = create(:invoice, merchant: merchant_2, customer: customer_2)
      transaction_1 = create(:transaction, invoice: invoice_1, result: "success")
      transaction_2 = create(:transaction, invoice: invoice_2, result: "success")
      invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 99, unit_price: 5)
      invoice_item_2 = create(:invoice_item, invoice: invoice_2, item: item_2, quantity: 100, unit_price: 2)

      expected_attributes = {
        name: merchant_2.name,
        quantity: 100
      }

      expect(Merchant.sold_most_items(2).first.name).to eq(merchant_2.name)
      expect(Merchant.sold_most_items(2).first.count).to eq(invoice_item_2.quantity)
    end
  end
end