require 'rails_helper'

RSpec.describe 'Merchant', type: :request do
  describe 'Find Merchant Revenue' do
    it 'can fetch a specific merchants revenue' do
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
      invoice_item_3 = create(:invoice_item, invoice: invoice_2, item: item_2, quantity: 1, unit_price: 2)

      expected_revenue = 202.00

      get "/api/v1/revenue/merchants/#{merchant_2.id}"

      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(json[:data]).to be_a(Hash)
      expect(json[:data][:attributes][:revenue]).to eq(expected_revenue)
    end
  end
end