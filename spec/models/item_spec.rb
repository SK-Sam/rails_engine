require 'rails_helper'

RSpec.describe Item do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price}
  end
  describe 'class methods' do
    it '#find_by_args' do
      merchant = create(:merchant)
      item_1 = create(:item, merchant: merchant, unit_price: 50.00)
      item_2 = create(:item, merchant: merchant, unit_price: 25.00)
      item_3 = create(:item, merchant: merchant, unit_price: 1.00)

      item_name_to_find_by = item_1.name[0..3]
      item_price_min_to_find_by = 25.00
      item_price_max_to_find_by = 24

      expect(Item.find_by_args(nil, nil, item_name_to_find_by)).to eq([item_1])
      expect(Item.find_by_args(item_price_min_to_find_by, nil, nil)).to eq([item_1, item_2])
      expect(Item.find_by_args(nil, item_price_max_to_find_by, nil)).to eq([item_3])
      expect(Item.find_by_args(item_1.unit_price, item_1.unit_price, item_1.name.upcase)).to eq([item_1])
      expect(Item.find_by_args(nil, nil, nil)).to eq([])
      expect(Item.find_by_args(Float::MAX, Float::MAX, "20")).to eq([])
    end
  end
end