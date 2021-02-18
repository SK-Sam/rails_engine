require 'rails_helper'

RSpec.describe Merchant do
  describe 'relationships' do
    it { should have_many :items }
    it { should have_many :invoices }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:invoice_items).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end
  describe 'validations' do
    it { should validate_presence_of :name }
  end
  describe 'class methods' do
    it '#handle_pagination' do
      create_list(:merchant, 21)
      five_per_page = Merchant.handle_pagination(5)

      expect(five_per_page.count).to eq(5)

      page_two = Merchant.handle_pagination(20, 2)

      expect(page_two.count).to eq(1)
      expect(page_two.first).to eq(Merchant.all.last)

      default_args = Merchant.handle_pagination

      expect(default_args.count).to eq(20)

      over_limit_twenty = Merchant.handle_pagination(21)

      expect(over_limit_twenty.count).to eq(20)

      nil_handling = Merchant.handle_pagination(nil, nil)

      expect(nil_handling.count).to eq(20)
    end
    it '#find_by_name_alphabetical' do
      incorrect_merchant = create(:merchant, name: "Turing")
      correct_merchant = create(:merchant, name: "Ring World")

      expect(Merchant.find_by_name_alphabetical("ring")).to eq(correct_merchant)
      expect(Merchant.find_by_name_alphabetical("Ring")).to eq(correct_merchant)
    end
  end
end