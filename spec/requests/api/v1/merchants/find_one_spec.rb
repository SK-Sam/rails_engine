require 'rails_helper'

RSpec.describe 'Find One', type: :request do
  describe 'fetching a merchant' do
    it 'can fetch a specific merchant based on name' do
      incorrect_merchant = create(:merchant, name: "Turing")
      correct_merchant = create(:merchant, name: "Ring World")

      expected_attributes = {
        name: correct_merchant.name
      }

      get '/api/v1/merchants/find?name=Ring'

      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expected_attributes.each do |attribute, value|
        expect(json[:data][:attributes][attribute]).to eq(value)
      end
    end
    it 'can fetch a specific merchant based on name case insensitive' do
      incorrect_merchant = create(:merchant, name: "Turing")
      correct_merchant = create(:merchant, name: "Ring World")

      expected_attributes = {
        name: correct_merchant.name
      }

      get '/api/v1/merchants/find?name=ring'

      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expected_attributes.each do |attribute, value|
        expect(json[:data][:attributes][attribute]).to eq(value)
      end
    end
    it 'can return an error if no match found' do
      get '/api/v1/merchants/find?name=NOMATCH'

      expect(response.status).to eq(404)
    end
  end
end