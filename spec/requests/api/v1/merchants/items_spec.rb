require 'rails_helper'

RSpec.describe 'Merchants', type: :request do
  describe 'fetching items a merchant owns' do
    it 'can fetch at most 20 items at a time' do
      merchant = create(:merchant)
      item_list = create_list(:item, 22, merchant: merchant)

      get api_v1_merchant_items_path(merchant)
      
      expect(response.status).to eq(200)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data].count).to eq(22)
      expect(json[:data].class).to eq(Array)
      expect(json[:data].first).to eq("hello")
    end
    xit 'can fetch merchants based on pages' do
      merchant_list = create_list(:merchant, 21)
      get '/api/v1/merchants?per_page=20&page=2'
      
      expect(response.status).to eq(200)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data].count).to eq(1)
    end
  end
end