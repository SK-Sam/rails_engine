require 'rails_helper'

RSpec.describe 'Invoice', type: :request do
  describe 'Find Invoice Revenue' do
    it 'can fetch an invoice revenue from unshipped invoices' do
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)
      item_1 = create(:item, merchant: merchant_1)
      item_2 = create(:item, merchant: merchant_2)
      customer_1 = create(:customer)
      customer_2 = create(:customer)
      invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1, status: packaged)
      invoice_2 = create(:invoice, merchant: merchant_2, customer: customer_2)
      transaction_1 = create(:transaction, invoice: invoice_1, result: "success")
      transaction_2 = create(:transaction, invoice: invoice_2, result: "success")
      invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 99, unit_price: 5)
      invoice_item_2 = create(:invoice_item, invoice: invoice_2, item: item_2, quantity: 100, unit_price: 2)
      invoice_item_3 = create(:invoice_item, invoice: invoice_2, item: item_2, quantity: 1, unit_price: 2)

      expected_potential_revenue = 495.00

      get "/api/v1/revenue/unshipped?quantity=2"

      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(json[:data]).to be_an(Array)
      expect(json[:data].first[:attributes][:potential_revenue]).to eq(expected_potential_revenue)
    end
  end
end