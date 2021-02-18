require 'rails_helper'

RSpec.describe 'Find One', type: :request do
  describe 'fetching all items' do
    it 'can fetch specific items based on min value only' do
      merchant = create(:merchant)
      item_1 = create(:item, merchant: merchant, unit_price: 50.00)
      item_2 = create(:item, merchant: merchant, unit_price: 25.00)
      item_3 = create(:item, merchant: merchant, unit_price: 1.00)

      expected_attributes = {
        name: item_1.name,
        description: item_1.description,
        unit_price: item_1.unit_price,
        merchant_id: item_1.merchant_id
      }

      get '/api/v1/items/find_all?min_price=26'

      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expected_attributes.each do |attribute, value|
        expect(json[:data].first[:attributes][attribute]).to eq(value)
      end
    end
  end
end