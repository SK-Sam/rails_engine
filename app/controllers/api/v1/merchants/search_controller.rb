class Api::V1::Merchants::SearchController < ApplicationController
  def find
    @merchant = Merchant.find_by_name_alphabetical(params[:name])
    render json: MerchantSerializer.new(@merchant)
  end

  def most_items
    @merchants = Merchant.sold_most_items(params[:quantity])
    render json: ItemsSoldSerializer.new(@merchants)
  end
end

