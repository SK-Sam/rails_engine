require 'rails_helper'
RSpec.describe 'Merchants', type: :request do
  describe 'fetching a single merchant' do
    it 'succeeds when there is something to fetch' do
      merchant = create(:merchant)
      expected_attributes = {
        name: merchant.name
      }
      # get "/api/v1/merchants/#{merchant.id}"
      get api_v1_merchant_path(merchant.id)

      expect(response.status).to eq(200)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:id]).to eq(merchant.id.to_s)
      # expect that every attribute we want up above shows up in our output
      expected_attributes.each do |attribute, value|
        expect(json[:data][:attributes][attribute]).to eq(value)
      end
    end
    it 'fails with 404 if merchant does not exist' do
      get api_v1_merchant_path(999999)
      expect(response.status).to eq(404)
      # as an extension, you can make a custom error message, but a 404 with an empty "data" structure from the serializer is fine too
      # json = JSON.parse(response.body, symbolize_names: true)
      # expect(json).to have_key(:error)
      # expect(json[:error]).to eq('resource could not be found')
    end
  end
  # from here you can add other tests like "get all merchants" etc
end