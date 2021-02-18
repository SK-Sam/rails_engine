class Api::V1::Merchants::SearchController < ApplicationController
  def find
    @merchant = Merchant.find_by_name_alphabetical(params[:name])
    render json: MerchantSerializer.new(@merchant)
  end
end

