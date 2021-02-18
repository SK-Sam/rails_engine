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
  describe 'creating an item' do
    it 'succeeds when proper attributes are given' do
      merchant = create(:merchant)
      name = "Item"
      description = "Description"
      unit_price = 20.1
      item_params = ({
        name: name,
        description: description,
        unit_price: unit_price,
        merchant_id: merchant.id
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post api_v1_items_path, headers: headers, params: JSON.generate(item: item_params)
      created_item = Item.last

      expect(response).to be_successful
      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])
    end
  end
  describe 'patching an item' do
    it 'succeeds when proper attributes are given' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)
      headers = {"CONTENT_TYPE" => "application/json"}
      previous_item_name = item.name
      updated_name = "Updated Name" 

      patch api_v1_item_path(item.id), headers: headers, params: JSON.generate(item: {name: updated_name})
      updated_item = Item.find(item.id)

      expect(response).to be_successful
      expect(updated_item.name).not_to eq(previous_item_name)
      expect(updated_item.name).to eq(updated_name)
    end
  end
  describe 'destroying an item' do
    it 'succeeds and destroys invoice if it is the only item on invoice' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)
      
      delete api_v1_item_path(item.id)

      expect(response.status).to eq(204)
      expect(response).to be_successful
      expect(Item.exists?(item.id)).to eq(false)
    end
  end
  describe 'fetching the merchant of the item' do
    it 'succeeds when getting the merchant who owns the item' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)
      expected_attributes = {
        name: merchant.name
      }
      
      get api_v1_item_merchant_index_path(item.id)
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(response).to be_successful
      expected_attributes.each do |attribute, value|
        expect(json[:data][:attributes][attribute]).to eq(value)
      end
    end
  end
end