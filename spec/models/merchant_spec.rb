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
    end
  end
end