require 'rails_helper'

RSpec.describe 'Items', type: :request do
  describe 'fetching all items' do
    it 'can fetch at most 20 items at a time' do
      merchant = create(:merchant)
      item_list = create_list(:item, 22, merchant: merchant)
      first_item = item_list.first
      expected_attributes = {
        name: first_item.name,
        description: first_item.description,
        unit_price: first_item.unit_price,
        merchant_id: first_item.merchant_id
      }

      get api_v1_items_path
      
      expect(response.status).to eq(200)

      json = JSON.parse(response.body, symbolize_names: true)

      expected_attributes.each do |attribute, value|
        expect(json[:data].first[:attributes][attribute]).to eq(value)
      end
    end
  end
  describe 'fetching a single item' do
    it 'succeeds when there is something to fetch' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)
      expected_attributes = {
        name: item.name,
        description: item.description,
        unit_price: item.unit_price,
        merchant_id: item.merchant_id
      }

      get api_v1_item_path(item.id)

      expect(response.status).to eq(200)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:id]).to eq(item.id.to_s)
      # expect that every attribute we want up above shows up in our output
      expected_attributes.each do |attribute, value|
        expect(json[:data][:attributes][attribute]).to eq(value)
      end
    end
  end
end