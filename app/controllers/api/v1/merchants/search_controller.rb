class Api::V1::Merchants::SearchController < ApplicationController
  def find
    @merchant = Merchant.find_by_name_alphabetical(params[:name])
    if @merchant == nil
      render json: { data: {} }, status: 404
    else
      render json: MerchantSerializer.new(@merchant)
    end
  end

  def most_items
    if params[:quantity] == nil
      render json: {error: "Quantity is missing"}, status: 400
    else
      @merchants = Merchant.sold_most_items(params[:quantity])
      render json: ItemsSoldSerializer.new(@merchants)
    end
  end
end

