require 'rails_helper'

RSpec.describe 'Merchant Items', type: :request do
  describe 'fetching items a merchant owns' do
    it 'can fetch all Merchant items' do
      merchant = create(:merchant)
      item_list = create_list(:item, 22, merchant: merchant)

      get api_v1_merchant_items_path(merchant.id)
      
      expect(response.status).to eq(200)

      json = JSON.parse(response.body, symbolize_names: true)

      first_item = Item.first

      expected_object = {
        attributes: {
          name: first_item.name,
          description: first_item.description,
          unit_price: first_item.unit_price,
          merchant_id: first_item.merchant_id
        }
      }
      expect(json[:data].count).to eq(22)
      expect(json[:data].class).to eq(Array)
      expect(json[:data].first[:name]).to eq(expected_object[:name])
      expect(json[:data].first[:description]).to eq(expected_object[:description])
      expect(json[:data].first[:unit_price]).to eq(expected_object[:unit_price])
      expect(json[:data].first[:merchant_id]).to eq(expected_object[:merchant_id])
    end
  end
end